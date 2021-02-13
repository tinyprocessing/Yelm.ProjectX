//
//  location.swift
//  Yelm.ProjectX
//
//  Created by Michael on 08.01.2021.
//

import Foundation
import SwiftUI
import UIKit
import Yelm_Server

struct ModalLocation: View {
    
    @ObservedObject var realm: RealmLocations = GlobalRealmLocations
    @ObservedObject var modal : ModalManager = GlobalModular
    
    
    @ObservedObject var location : location_cache = GlobalLocation

    
    @State var showmap : Bool = false
    var body: some View {
        
        VStack(){
            Spacer()
            
            HStack{
                Spacer()
                Rectangle()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .frame(width: 30, height: 5)
                    .opacity(0.4)
                Spacer()
            }.padding(.bottom, 5)
            VStack(){
                Text("")
                    .frame(width: 10, height: 20)
                HStack{
                    Text("Мои адреса")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    
                    Spacer()
                }.onAppear{
                    self.realm.get_locations()
                }
              
                if (self.realm.locations.count > 0){
                    ForEach(self.realm.locations, id: \.self) { row in
                    
                    
                    HStack{
                        
                        Button(action: {
                            
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            
                            
                            ServerAPI.settings.position = row.point

                            UserDefaults.standard.set(row.name, forKey: "SELECTED_SHOP_NAME")
                            UserDefaults.standard.set(row.point, forKey: "SELECTED_SHOP_POINTS")
                            
                            self.location.name = UserDefaults.standard.string(forKey: "SELECTED_SHOP_NAME") ?? "Выберите адрес"
                            self.location.point = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
                            
                            
                        }) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 25, weight: .medium, design: .rounded))
                                .foregroundColor(self.location.point == row.point ? Color.theme : .gray)
                        }.buttonStyle(ScaleButtonStyle())
                        
                        Text("\(row.name)")
                        Spacer()
                        VStack{
                           
                        }
                            .frame(height: 30)
                            .frame(width: 1)
                            .background(Color.gray)
                            .opacity(0.4)
                            .padding(.trailing, 10)
                        Button(action: {
                          
                            self.realm.delete_location(ID: row.id)
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()

                            self.realm.objectWillChange.send()
                            self.realm.get_locations()
                            
                            if (self.realm.locations.count == 1){

                                ServerAPI.settings.set_position(point: self.realm.locations[0].point)

                                UserDefaults.standard.set(self.realm.locations[0].name, forKey: "SELECTED_SHOP_NAME")
                                UserDefaults.standard.set(self.realm.locations[0].point, forKey: "SELECTED_SHOP_POINTS")
                                
                                self.location.name = UserDefaults.standard.string(forKey: "SELECTED_SHOP_NAME") ?? "Выберите адрес"
                                self.location.point = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"

                            }else{
                                if (ServerAPI.settings.position == row.point && self.realm.locations.count > 0){
                                    ServerAPI.settings.position = self.realm.locations.last!.point
                                    

                                    UserDefaults.standard.set(self.realm.locations.last?.name, forKey: "SELECTED_SHOP_NAME")
                                    UserDefaults.standard.set(self.realm.locations.last?.point, forKey: "SELECTED_SHOP_POINTS")
                                    
                                    self.location.name = UserDefaults.standard.string(forKey: "SELECTED_SHOP_NAME") ?? "Выберите адрес"
                                    self.location.point = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"

                                }
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                                self.realm.objectWillChange.send()
                                self.realm.get_locations()
                            }
                            
                            
                        }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        }.buttonStyle(ScaleButtonStyle())
                    }.frame(height: 55)

                    
                }
                }
                    
                   
                    HStack{
                        
                        Button(action: {
                            self.showmap.toggle()
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 25, weight: .medium, design: .rounded))
                                .foregroundColor(.theme)
                            Text("Добавить новый")
                                .foregroundColor(.theme_black_change)
                           
                        }
                        
                        .compatibleFullScreen(isPresented: $showmap){
                            MapLocations()
                                .edgesIgnoringSafeArea(.all)
                        }
                        

                     
                        
                      
                        Spacer()
                    }.padding(.vertical)
                    
            
                
                HStack{
                   
                    Button(action: {
                        
                        if (self.realm.locations.count > 0){
                            self.modal.objectWillChange.send()
                            self.modal.closeModal()
                            self.realm.get_locations()

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { 
                                windows?.rootViewController =  UIHostingController(rootView: Start())
                            }

                        }else{
                            ShowAlert(title: "Уведомление", message: "Вы должны добавить как минимум одну точку доставки для отображения товаров")
                            self.realm.get_locations()
                        }
                  
                     
                        
                    }) {
                        HStack{
                            Spacer()
                            Text("Готово")
                            Spacer()
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                    }.buttonStyle(ScaleButtonStyle())
                   
                }.padding(.bottom, 30)
                
                    
            }.padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .background(Color.theme_black_change_reverse)
            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 30))
        }.frame(width: UIScreen.main.bounds.width)

        
    }
}
