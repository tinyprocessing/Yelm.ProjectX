//
//  history_item.swift
//  Yelm.ProjectX
//
//  Created by Michael on 05.02.2021.
//

import SwiftUI
import Yelm_Server

struct history_item: View {
    
    
    @State var item : items_structure = items_structure(id: 0)
    
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                
                
                URLImage(URL(string: self.item.thubnail)!) { proxy in
                    proxy.image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
                
                VStack{
                 
                    
             
                    VStack(alignment: .leading, spacing: 5) {
                            
                            Text(self.item.title)
                                .padding(.bottom, self.item.discount_present == "-0%" ? 5 : 0)
                            
                            HStack{
                                if (self.item.discount_present != "-0%"){
                                    Text("\(self.item.discount_present)")
                                        .foregroundColor(Color.white)
                                        .padding([.top, .leading, .bottom, .trailing], 7)
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .background(Color.green)
                                        .clipShape(Capsule())
                                        .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                                        .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                                
                                }
                                
                                Rating(item: items(id: self.item.id, item: self.item))
                                
                            }
                        
                            HStack{
                                
                                Text("\(self.item.quanity) / \(self.item.type)")
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(self.item.discount) \(ServerAPI.settings.symbol)")
                                    .foregroundColor(.black)
                                
                            }
                            
                          
                            
                            
                            
                        }
                        
                        .padding(.horizontal, 20)
                        
                        
                        
                    
                }
                
                Spacer()
                

                
            }.padding([.top, .bottom], 5)
           
        }
    }
}

