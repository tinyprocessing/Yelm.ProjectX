//
//  webview.swift
//  Yelm.ProjectX
//
//  Created by Michael on 18.01.2021.
//

import Foundation
import WebKit
import UIKit
import SwiftUI

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
    var webview: WKWebView = WKWebView()

    
    class Coordinator: NSObject, WKNavigationDelegate {
    
        @ObservedObject var status: loading_webview = GlobalWebview

        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated  {
                       if let url = navigationAction.request.url,
                           let host = url.host, !host.hasPrefix("https://yelm.io"),
                           UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url)
                           print(url)
                           print("Redirected to browser. No need to open it locally")
                           decisionHandler(.cancel)
                       } else {
                           print("Open it locally")
                           decisionHandler(.allow)
                       }
                   } else {
                       print("not a user click")
                       decisionHandler(.allow)
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            let js = "document.getElementsByTagName('body')[0].style.color='#000000'; document.getElementsByTagName('img')[0].style.width='100%'; "
            webView.evaluateJavaScript(js) { (response, error) in
                
                
       
            }
            
        
            webView.evaluateJavaScript("document.documentElement.scrollHeight") { (response, error) in
                DispatchQueue.main.async {
                    self.status.height = 0
                    self.status.height = response as! CGFloat
                    print(response)
                    print("I has found height")
                }
            }


        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
    
       
        
        
        let htmlEnd = "</BODY></HTML>"
        let dummy_html = htmlContent
        let htmlString = "\(html_start)\(dummy_html)\(htmlEnd)"
        
        print(htmlString.count)
        
        webview.loadHTMLString(htmlString, baseURL:  nil)
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    
    }
}
