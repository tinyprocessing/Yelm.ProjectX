//
//  item_images.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 18.04.2021.
//

import SwiftUI
import Yelm_Server


struct item_images: View {
    
 
    
    @ObservedObject var item: items = GlobalItems
    @ObservedObject var image_view: image_view = GlobalImageView

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

                    ForEach(self.item.item.all_images, id: \.self) { image in

                        Button(action: {
                            self.image_view.objectWillChange.send()
                            self.image_view.image = image
                            self.image_view.objectWillChange.send()
                            self.image_view.show = true
                            
                            print("press it")
                        }) {

                            URLImage(URL(string: image)!) { proxy in
                                proxy.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                            }

                        }

                        .buttonStyle(ScaleButtonStyle())


                    }


                }.padding(.leading, 20)
            }
        }
        .padding(.bottom)
       
       
    }
}

