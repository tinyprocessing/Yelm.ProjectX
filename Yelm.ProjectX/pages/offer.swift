//
//  offer.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server


struct Offer: View {
    

    @ObservedObject var location : location_cache = GlobalLocation
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var item: items = GlobalItems
    @State var nav_bar_hide: Bool = true
    
    @Environment(\.presentationMode) var presentation
    
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = Color.theme.uiColor()
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: Color.theme_foreground.uiColor()], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    @State var pickerSelection = 0
    
    @State var isNavigationBarHidden: Bool = true

    
    @State var selection: Int? = nil
    
    @State var promocode: String = ""
    
    @ObservedObject var realm: RealmControl = GlobalRealm

    
    var body: some View {
        
        
        
        ZStack(alignment: .bottom){
            VStack{

                
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
                                .padding(.trailing, 10)
                                .buttonStyle(ScaleButtonStyle())
                            
                            Text("Оформление")
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
                
                
                ScrollView(showsIndicators: false) {
                
                    HStack(){
                        Text("Промокод")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                        Spacer()
                    }.padding(.bottom , 8)
                    
                    
                    TextField("Промокод", text: $promocode)
                        .padding(.vertical, 10)
                        .foregroundColor(Color.init(hex: "BDBDBD"))
                        .padding(.leading, 10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                                   RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.init(hex: "E0E0E0"), lineWidth: 2)
                                        .opacity(0.6)
                                        .overlay(
                                            HStack{
                                                Spacer()
                                                
                                                
                                                Button(action: {
                                                    
                                                    print("Some PLUS touch")
                                                    

                                                }) {
                                                    
                                                    Rectangle()
                                                        .fill(Color.theme)
                                                        .frame(width: 50)
                                                        .clipShape(CustomShape(corner: [.topRight, .bottomRight], radii: 8))
                                                        .overlay(
                                                            Image(systemName: "wand.and.rays")
                                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                                .foregroundColor(.theme_foreground)
                                                        )

                                                }
                                                .buttonStyle(PlainButtonStyle())

                                                
                                            }
                                        )
                            )
                        .padding(.horizontal, 1)
                        .padding(.bottom , 8)
                    
                    HStack(){
                        Text("Адрес")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                        Spacer()
                    }.padding(.bottom , 5)
                    
                    HStack(){
                        Text(self.location.name)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.init(hex: "828282"))

                            
                        Spacer()
                    }.padding(.bottom , 5)
                    
                    
                    HStack(spacing: 10){
                        
                        
                        TextField("Подъезд", text: $promocode)
                            .padding(.vertical, 10)
                            .foregroundColor(Color.init(hex: "BDBDBD"))
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                       RoundedRectangle(cornerRadius: 8)
                                           .stroke(Color.init(hex: "E0E0E0"), lineWidth: 2)
                                        .opacity(0.6)
                                )
                            .padding(.horizontal, 1)
                            .padding(.bottom , 8)
                        
                        
                        TextField("Этаж", text: $promocode)
                            .padding(.vertical, 10)
                            .foregroundColor(Color.init(hex: "BDBDBD"))
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                       RoundedRectangle(cornerRadius: 8)
                                           .stroke(Color.init(hex: "E0E0E0"), lineWidth: 2)
                                        .opacity(0.6)
                                )
                            .padding(.horizontal, 1)
                            .padding(.bottom , 8)
                        
                        
                        TextField("Квартира", text: $promocode)
                            .padding(.vertical, 10)
                            .foregroundColor(Color.init(hex: "BDBDBD"))
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                       RoundedRectangle(cornerRadius: 8)
                                           .stroke(Color.init(hex: "E0E0E0"), lineWidth: 2)
                                        .opacity(0.6)
                                )
                            .padding(.horizontal, 1)
                            .padding(.bottom , 8)
                    }
                    
                    
                    HStack(){
                        Text("Получатель")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                        Spacer()
                    }.padding(.bottom , 8)
                    
                    TextField("Номер телефона", text: $promocode)
                        .padding(.vertical, 10)
                        .foregroundColor(Color.init(hex: "BDBDBD"))
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                                   RoundedRectangle(cornerRadius: 8)
                                       .stroke(Color.init(hex: "E0E0E0"), lineWidth: 2)
                                    .opacity(0.6)
                            )
                        .padding(.horizontal, 1)
                        .padding(.bottom , 8)
                    
                    

                    
                    
                    VStack{
                        HStack(){
                            Text("Ваш заказ")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                
                            Spacer()
                        }.padding(.bottom , 8)
                        
                        
                        HStack(){
                            Text("Товары")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.init(hex: "828282"))
                                
                            Spacer()
                            
                            Text("720 руб")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.theme)
                        }.padding(.bottom , 5)
                        
                        
                        HStack(){
                            Text("Скидка 5%")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.red)
                                
                            Spacer()
                            
                            Text("-86 руб")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.red)
                        }.padding(.bottom , 5)
                        
                        
                        HStack(){
                            Text("Доставка")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.init(hex: "828282"))
                                
                            Spacer()
                            
                            Text("-86 руб")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.theme)
                        }.padding(.bottom , 8)
                    }
                    
                    
                    HStack(){
                        Text("Способ оплаты")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                        Spacer()
                    }.padding(.bottom , 5)
                    
                   
                    
                    Picker(selection: $pickerSelection, label: Text("")) {
                               Text("Карта")
                                .tag(0)
                                .foregroundColor(Color.theme_foreground)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                
                               Text("Apple Pay")
                                .tag(1)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    
                    
                }.padding([.trailing, .leading], 20)

                
                
                
                
            }
            
         
            
            
            
            VStack(spacing: 0){
                HStack(spacing: 15){
                    VStack(spacing: 5){
                        Text("\(String(format:"%.2f", self.realm.price)) \(ServerAPI.settings.symbol)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.theme)
                        Text("Итого")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    
                    
                    
                    Button(action: {
                        

                    }) {
                        
                        HStack{
                            Spacer()
                            Text("Оплатить")
                            Spacer()
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                         


                    }

                    .frame(height: 50)
                    .buttonStyle(ApplePayButtonStyle())
                    .clipShape(CustomShape(corner: .allCorners, radii: 10))
                    
                    
                    
//                        Кнопка для покупки
//                        Данные о сумме заказа
                }.padding([.trailing, .leading], 20)
            }
            .padding(.bottom, 40)
            .padding(.top, 30)
            .background(Color.white)
            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 20))
//                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
            .shadow(color: .dropShadow, radius: 15, x: 0, y: 2)

            
        }.edgesIgnoringSafeArea(.bottom)
        
        
      
    
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
           
       }
       
     
        .onDisappear{
            open_offer = false
        }
       

    }
}

