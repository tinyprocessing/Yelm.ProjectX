//
//  catalog.swift
//  Yelm.ProjectX
//
//  Created by Michael on 18.02.2021.
//

import SwiftUI
import Grid


struct catalog: View {
    
    
    @State var images : [String] = ["https://images.grocery.yandex.net/2756334/224c8808a5fd41908261a104b7f80b4e/400x400.png",
                                    "https://images.grocery.yandex.net/2750890/7c93a9a8810a45849734d50cc01c7770/400x400.jpeg",
                                    "https://images.grocery.yandex.net/2888787/4ec36c206f5849d39eec98097d7bed51/400x400.jpeg"]
    
    var body: some View {
        
        VStack(spacing: 10){
            if (true){
                HStack{
                    Text("Категории")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    
                    Spacer()
                }
                .padding(.leading, 15)
                
                
                Grid(self.images, id: \.self) { tag in

                    ZStack(alignment: .topLeading){
                        URLImage(URL(string: tag)!) { proxy in
                            proxy.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: (UIScreen.main.bounds.width-40)/3, height: (UIScreen.main.bounds.width-40)/3)
                                .cornerRadius(20)
                        }
                        
                        Text("Булочная")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .padding()
                    }
                    
                   
                    
                }.gridStyle(
                    
                    ModularGridStyle(columns: 3, rows: .fixed((UIScreen.main.bounds.width-40)/3))
                )
                .frame(width: UIScreen.main.bounds.width-30)
                
                
                
                
                

                
            }
            
        }
        .padding(.bottom, 10)
    }
}


