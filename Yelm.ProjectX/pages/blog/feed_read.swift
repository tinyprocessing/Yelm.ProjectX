//
//  feed_read.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 12.04.2021.
//

import Foundation
import SwiftUI
import Combine
import Yelm_Server

struct Feed_Read: View {
    
    
    @State var selection: String? = nil
    @ObservedObject var item: items = GlobalItems

    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var search_server : search = GlobalSearch

    @State var nav_bar_hide: Bool = true
    
    
    @Environment(\.presentationMode) var presentation
    
    @State var search : String = ""
    var body: some View {
        VStack{
            
            VStack{
                
                    HStack(alignment: .center){
                        Button(action: {
                            
                                self.presentation.wrappedValue.dismiss()
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                         
                        }) {

                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color.theme_foreground)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 10)

                                .font(.system(size: 15, weight: .bold, design: .rounded))

                                .background(Color.theme)
                                .clipShape(Circle())

                        }
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                            .buttonStyle(ScaleButtonStyle())
                        
                        Text("Новость")
                            .padding(.top, 10)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                         
                        Spacer()
                    }
                    
            }
            .padding([.trailing, .leading], 20)
            .padding(.bottom, 10)
            .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)

    
            WebView(request: URLRequest(url: URL(string: "https://wylsa.com/konczept-chehol-dlya-iphone-v-stile-mac-pro/")!))

            
            Spacer()
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
        }
        
        .onDisappear{
            if (open_item == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }
        }
    }
}


import WebKit

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}
