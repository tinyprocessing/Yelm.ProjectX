//
//  ContentView.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import SwiftUI
import Yelm_Server



struct Start: View {
    
    
    @ObservedObject var realm: RealmControl = GlobalRealm

    @State var nav_bar_hide: Bool = true
    @State var items : [items_main_cateroties] = []
    
    var body: some View {
       
        ZStack(alignment: .bottomLeading){
            NavigationView{
                VStack{
                    
                    Home(items: self.$items)

                }
                
                .edgesIgnoringSafeArea(.bottom)
                .accentColor(Color("BLWH"))
                .navigationBarTitle("hidden_layer")
                .navigationBarHidden(self.nav_bar_hide)
            }
            
            HStack{
                
                
                if (true){
                    Button(action: {
                        
                        withAnimation{
                            windows?.rootViewController =  UIHostingController(rootView: Start())
                        }

                    }) {
                        HStack{
                            Image(systemName: "house.fill").font(.system(size: 16, weight: .bold, design: .rounded))
                          
                        }
                        .padding()
                        .frame(height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())

                    }.buttonStyle(ScaleButtonStyle())
                }
                
              
                
                Spacer()
                
                if (true){
                    
                    Button(action: {


                    }) {
                        HStack{
                            Image(systemName: "cart").font(.system(size: 16, weight: .bold, design: .rounded))
                            Text("\(String(format:"%.2f", self.realm.price))").font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .padding()
                        .frame(height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)

                    }.buttonStyle(ScaleButtonStyle())
                    
                }
             
                
                
          
            }
            .padding()
            .padding(.bottom, 20)

            
        }.edgesIgnoringSafeArea(.bottom)
      
        
            .onAppear{
                self.nav_bar_hide = true
                self.realm.get_total_price()
                ServerAPI.start(platform: "5fd33466e17963.29052139", position: "") { (result) in
                    if (result == true){
                        ServerAPI.settings.get_settings()
                        
                        ServerAPI.items.get_items { (load, items) in
                            if (load){
                                self.items = items
                            }
                        }
                    }
                }
            }
        
    }
}

