//
//  subcategories_grid_item.swift
//  Yelm.ProjectX
//
//  Created by Michael on 20.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server


struct SubcategoriesGridObject : View {
    
    @State var tag : items_structure
    @ObservedObject var realm: RealmControl = GlobalRealm
    
    var body: some View{
        
        VStack(alignment: .leading, spacing: 0){
            
            HStack{
                ZStack(alignment: .top){
                    URLImage(URL(string: tag.thubnail)!) { proxy in
                        proxy.image
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width-40)/2, height: (UIScreen.main.bounds.width-40)/2)
                            .cornerRadius(20)
                    }
                    .overlay(
                        Rectangle()
                            .fill(Color.black)
                            .cornerRadius(20)
                            .opacity( self.realm.get_item_access(ID: tag.id) ? 0.3 : 0)
                            .overlay(

                                VStack{
                                    if (self.realm.get_item_access(ID: tag.id)){
                                        Text(String(self.realm.get_items_count(ID: tag.id)))
                                            .font(.system(size: 40, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                            .frame(width: 100, height: 50)

                                    }

                                }
                            )





                    )
                    HStack(spacing: 0){

                        Spacer()

                        HStack{

                            if (tag.action.contains("1+1")){
                                VStack{
                                    Text("1+1")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .padding(5)
                                        .padding(.horizontal, 10)
                                        .foregroundColor(.white)
                                }
                                .background(Color.orange)
                                .cornerRadius(20)
                                .padding(.top, 7)
                                .padding(.trailing, 5)
                            }

                        }

                        HStack{

                            if (tag.discount_present != "-0%"){

                                VStack{
                                    Text("\(tag.discount_present)")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .padding(5)
                                        .padding(.horizontal, 10)
                                        .foregroundColor(.white)
                                }
                                .background(Color.green)
                                .cornerRadius(20)
                                .padding(.top, 7)
                                .padding(.trailing, 7)

                            }
                        }
                    }

                }
            }
            
            VStack{
                Text("\(tag.title) ").font(.system(size: 14, weight: .regular, design: .rounded)) + Text("\(tag.quanity) \(tag.type)").foregroundColor(Color.gray).font(.system(size: 14, weight: .regular, design: .rounded))
            }
            .frame(height: 60)
            .lineSpacing(2)
            
            
            HStack{

                HStack(spacing: 0){

                    if (self.realm.get_item_access(ID: tag.id)){


                        Button(action: {


                            self.realm.post_cart(ID: tag.id, method: "decrement")


                        }) {

                            Rectangle()
                                .fill(Color.theme)
                                .frame(width: 14, height: 26)
                                .overlay(
                                    Image(systemName: "minus")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(.theme_foreground)
                                )




                        }

                        .padding(.leading, 8)
                        .padding(.trailing, 5)
                        .buttonStyle(PlainButtonStyle())

                    }


                    Text("\(tag.discount) \(ServerAPI.settings.symbol)")
                        .lineLimit(1)
                        .foregroundColor(.theme_foreground)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding([.top, .bottom], 7)
                        .background(Color.theme)
                        .cornerRadius(20)
                        .fixedSize()
                        .padding(.leading, self.realm.get_item_access(ID: tag.id) ? 0 : 12)


                    Button(action: {



                        if (self.realm.get_item_access(ID: tag.id) == false) {


                            self.realm.objectWillChange.send()
                            self.realm.create_item_cart(ID: tag.id, Title: tag.title, Price: tag.price_float, PriceItem: tag.price_float, Count: 1, Thumbnail: tag.thubnail, ItemType: tag.type, Quantity: tag.quanity, CanIncrement: "1", Discount: tag.discount_value)


                            self.realm.objectWillChange.send()


                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                        }else{
                            self.realm.post_cart(ID: tag.id, method: "increment")
                        }




                    }) {

                        Rectangle()
                            .fill(Color.theme)
                            .frame(width: 14, height: 26)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.theme_foreground)
                            )

                    }
                    .padding(.trailing, 8)
                    .padding(.leading, 5)
                    .buttonStyle(PlainButtonStyle())

                }
                .background(Color.theme)
                .cornerRadius(20)

                Spacer()



            }
            
            Spacer()
            
        }
        .frame(height: 245)
        .padding(.top, 15)
        .padding(.bottom, 30)
    }
}
