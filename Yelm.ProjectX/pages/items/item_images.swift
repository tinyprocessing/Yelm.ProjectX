//
//  item_images.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 18.04.2021.
//

import SwiftUI
import Yelm_Server

struct item_images: View {
    
    @State var show: Bool = true
    @ObservedObject var item: items = GlobalItems

    var body: some View {
        VStack{
            HStack {

                Text("Фотографии")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()


            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 10){
                    
                    Color.red
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    
                    Color.red
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    
                    Color.red
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    
                }.padding(.leading, 20)
            }
        }
    }
}

struct item_images_Previews: PreviewProvider {
    static var previews: some View {
        item_images()
    }
}
