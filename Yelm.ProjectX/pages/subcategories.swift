//
//  subcategories.swift
//  Yelm.ProjectX
//
//  Created by Michael on 19.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server

struct Subcategories : View {
    
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @State var nav_bar_hide: Bool = true
    @Environment(\.presentationMode) var presentation

    @State var items : [items_main_cateroties] = []
    
    var body: some View{
        VStack{
            
            VStack{
                
                    HStack(alignment: .center){
                        Button(action: {
                            
                                self.presentation.wrappedValue.dismiss()
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                         
                        }) {

                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 10)

                                .font(.system(size: 15, weight: .bold, design: .rounded))

                                .background(Color.blue)
                                .clipShape(Circle())

                        }
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                            .buttonStyle(ScaleButtonStyle())
                        
                        Text("Товары")
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

//            Items show grid
            
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
                self.bottom.hide = false
            }
        }
        
    }
}
