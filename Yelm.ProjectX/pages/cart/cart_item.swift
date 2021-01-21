//
//  cart_item.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server


struct CartItem: View {
    
    @ObservedObject var realm: RealmControl = GlobalRealm

    @State var id : Int
    @State var title : String
    @State var image : String
    @State var price : String
    @State var price_float : Float
    @State var type : String
    @State var quanity : String
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                
                
                URLImage(URL(string: image)!) { proxy in
                      proxy.image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 0){
                    Text(title)
                        .lineLimit(2)
                        .padding(.leading, 10)
                    Spacer()
                    
                    HStack(spacing: 5){
                        
                        Button(action: {
                            
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            
                            self.realm.post_cart(ID: self.id, method: "decrement")
                         
                        }) {

                            Image(systemName: "minus")
                                .foregroundColor(Color.theme_foreground)
                                .frame(width: 12, height: 12, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 7)

                                .font(.system(size: 12, weight: .bold, design: .rounded))

                                .background(Color.theme)
                                .clipShape(Circle())

                        }
                            
                            .buttonStyle(ScaleButtonStyle())
                        
                        Text("\(self.realm.get_items_count(ID: self.id))")
                            .padding(.horizontal, 4)
                        
                        Button(action: {
                            
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            
                            self.realm.post_cart(ID: self.id, method: "increment")

                         
                        }) {

                            Image(systemName: "plus")
                                .foregroundColor(Color.theme_foreground)
                                .frame(width: 12, height: 12, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 7)

                                .font(.system(size: 12, weight: .bold, design: .rounded))

                                .background(Color.theme)
                                .clipShape(Circle())

                        }
                            
                            .buttonStyle(ScaleButtonStyle())
                        
                        
                    } .padding(.leading, 10)
                    
                    
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5){
                    Text("\(String(format:"%.2f", price_float)) \(ServerAPI.settings.symbol)")
                        .fontWeight(.semibold)
                        .foregroundColor(.theme)
                       
                    
                    Text("\(quanity) \(type) ")
                        .foregroundColor(.secondary)
                       
                } .padding(.horizontal, 10)
                
            
            }.padding([.top, .bottom], 5)
            Divider()
        }
    }
    
}
