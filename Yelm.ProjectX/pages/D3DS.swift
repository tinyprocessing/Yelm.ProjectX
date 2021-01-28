//
//  3d3s.swift
//  Yelm.ProjectX
//
//  Created by Michael on 26.01.2021.
//

import Foundation
import WebKit
import SwiftUI
import Combine
import SwiftyJSON
import Yelm_Pay

struct D3DS : UIViewRepresentable {

    
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        @Binding var open : Bool
        @ObservedObject var payment: payment = GlobalPayment

        
        init(open: Binding<Bool>) {
            _open = open
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let url = webView.url
            if url?.absoluteString == POST_BACK_URL {
                weak var wself = self
                webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (result, error) in
                    
                    let sself = wself
                    var str = result
                    repeat {
                        let startRange = (str as! NSString?)?.range(of: "{")
                        if startRange?.location == NSNotFound {
                            break
                        }
                        str = (str as! NSString?)?.substring(from: startRange?.location ?? 0)
                        let endRange = (str as! NSString?)?.range(of: "}")
                        if endRange?.location == NSNotFound {
                            break
                        }
                        str = (str as! NSString?)?.substring(to: (endRange?.location ?? 0) + 1)
                        var dict: [AnyHashable : Any]? = nil
                    
                        if (str != nil) {
                            let json = JSON.init(parseJSON: str as! String)

                            YelmPay.core.check_3d3s(id: json["MD"].string!, res: json["PaRes"].string!) { (payment, message) in
                                if (payment){
                                    self.payment.payment_done = true
                                    self.payment.message = message
                                    self.open.toggle()
                                    
                                }
                                
                                if (!payment){
                                    self.payment.payment_done = false
                                    self.payment.message = message
                                    self.open.toggle()
                                }
                            }

                        }
                        
                        return
                    } while false
                    
                }
            }
            
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(open: $open)
    }
    
    @Binding var response_main : HTTPURLResponse
    @Binding var data : Data
    @Binding var open : Bool
    
    func makeUIView(context: UIViewRepresentableContext<D3DS>) -> WKWebView {
        
        print(response_main)
        guard let url = self.response_main.url else { fatalError() }

        let view = WKWebView()
        view.scrollView.showsVerticalScrollIndicator = false
        view.navigationDelegate = context.coordinator
        view.allowsLinkPreview = false


        return view
        
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            uiView.load(data, mimeType: response_main.mimeType ?? "", characterEncodingName: response_main.textEncodingName ?? "", baseURL: response_main.url!)
        }
    }
}
