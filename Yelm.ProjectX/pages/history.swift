//
//  History.swift
//  Yelm.ProjectX
//
//  Created by Michael on 04.02.2021.
//

import SwiftUI
import Foundation
import Yelm_Server



struct History: View {
    
    
    @State var nav_bar_hide: Bool = true
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var items : [items_structure] = []
    @State var selection: Int? = nil
    @State var color = 0
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    @State var show : Float = 0.0
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var status: loading_webview = GlobalWebview

    @Environment(\.presentationMode) var presentation
    
  
    
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var opacity : Double = 0
    
    var body: some View{
        
        ZStack(alignment: .bottom){
            ZStack(alignment: .top){
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            
                            // First Parallax Scroll...
                            
                            GeometryReader{reader in
                                
                                VStack{
                                    
                                    
                                    URLImage(URL(string: "https://cdnimg.rg.ru/img/content/189/26/70/222_d_850.jpg")!) { proxy in
                                        proxy.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            // default widht...
                                            .frame(width: UIScreen.main.bounds.width+20, height: reader.frame(in: .global).minY > 0 ? CGFloat(Int(reader.frame(in: .global).minY + 245)) : 245)
                                            // adjusting view postion when scrolls...
                                            .offset(y: -reader.frame(in: .global).minY)
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                            // setting default height...
                            .frame(height: 200)
                            
                            // List Of Songs...
                            
                            VStack(spacing: 5){
                                
                                
                                if (true){
                                    
                                    GeometryReader{g in
                                        VStack{
                                            Text("")
                                        }
                                        .onReceive(self.time) { (_) in
                                            
                                            
                                            if (g.frame(in: .global).minY < 80){
                                                withAnimation{
                                                    self.show = 1.0
                                                }
                                            }else{
                                                withAnimation{
                                                    self.show = 0.0
                                                }
                                            }
                                        }
                                    } .frame(height: 0)
                                    
                                    HStack {
                                        
                                        
                                        Text("Статус: готово")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        
                                        
                                        Spacer()
                                        
                                        
                                        
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                                    
                                }
                                
                                
                                ZStack(alignment: .top){
                                    VStack(alignment: .leading){
                                      
                                        
                                        
                                        
                                        Spacer(minLength: UIScreen.main.bounds.height)
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            .padding(.vertical)
                            .background(Color.white)
                            .cornerRadius(40)

                            
                        } .background(Color.white)
                    }
                    
                }
                
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
                        .buttonStyle(ScaleButtonStyle())
                        
                        
                        
                        Spacer()
                        
                        if (self.show == 1.0){
                            Text("История заказов")
                                .padding(.top, 10)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                        }
                        
                        
                        
                        
                        Spacer()
                        
                        
                    
                        
                        
                        
                    }
                    .padding(.top, (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
                    .padding([.trailing, .leading], 20)
                    .padding(.bottom, 10)
                    .background(self.show == 1.0 ? Color.white : Color.clear)
                }
                
            }
            
            
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
        
        .onAppear {
            self.bottom.hide = true
            self.nav_bar_hide = true
        }
        
        .onDisappear{
            
            if (open_item == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }else{
                open_item = false
            }
        }
    }
    
    
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
