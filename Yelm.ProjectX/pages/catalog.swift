//
//  catalog.swift
//  Yelm.ProjectX
//
//  Created by Michael on 18.02.2021.
//

import SwiftUI
import Grid
import Yelm_Server

struct catalog: View {
    
    
    @ObservedObject var categories : categories = GlobalCategories
    @State var selection: String? = nil

    
    var body: some View {
        
        VStack(spacing: 10){
            if (true){
                HStack{
                    Text("Категории")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.theme_foreground)
                        .frame(width: 15, height: 15, alignment: .center)
                        .padding(7)
                        
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        
                        .background(Color.theme)
                        .clipShape(Circle())
                    
                }
                .padding(.bottom, 10)
                .frame(width: UIScreen.main.bounds.width-30)
                
                

                Grid(self.categories.all, id: \.self) { tag in

                    
                    
                    NavigationLink(destination: Subcategories(category_id: tag.id, name: tag.name), tag: "tag.id\(tag.id)", selection: $selection) {
                        
                        ZStack(alignment: .topLeading){
                            URLImage(URL(string: tag.image)!) { proxy in
                                proxy.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: (UIScreen.main.bounds.width-40)/2, height: (UIScreen.main.bounds.width-40)/2)

                                    .cornerRadius(20)
                            }

                            Text(tag.name)
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding()

                        }
                        
                    }.buttonStyle(ScaleButtonStyle())
                    
                 
//
                }.gridStyle(
                    ModularGridStyle(columns: 2, rows: .fixed((UIScreen.main.bounds.width-40)/2), spacing: 15)
                )
                .frame(width: UIScreen.main.bounds.width-30)
                
               
                
                
                
                
                

                
            }
            
        }
        .padding(.bottom, 10)
    }
}


