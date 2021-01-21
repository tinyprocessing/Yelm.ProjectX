//
//  add_location.swift
//  Yelm.ProjectX
//
//  Created by Michael on 08.01.2021.
//

import Foundation
import SwiftUI
import YandexMapKit
import YandexMapKitSearch
import MapKit


struct MapLocations: View {
    
    @State var location_update : Bool = false
    @State var location_manager : CLLocationManager = CLLocationManager()
    @State var location_map : YMKMapView = YMKMapView()
    @ObservedObject var location : location_cache = GlobalLocation

    @ObservedObject var realm: RealmLocations = GlobalRealmLocations
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @ObservedObject var service: MapService = GlobalMapService

    var body: some View {
            
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .center){
            ZStack{
  
                MapCreatePoint(YandexMap: $location_map, nativeLocationManagerNewValue: $location_manager, location_update_allow: $location_update)


                
                ZStack{
                    Text("\(service.name)")
                        .padding()
                        .background(Blur(style: .light))
                        .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                        .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                        .foregroundColor(.primary)
                    
                        .clipShape(CustomShape(corner: .allCorners, radii: 10))
                    
                        Image("map_pin")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .offset(y: 35)
                        
                }
                .offset(y: service.found ? -70 : -130)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))

            }
                Image("small_dump")
                    .resizable()
                    .frame(width: 25, height: 25)
                    
                
            }

            // тут кнопка
         
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        
                        Button(action: {

                            self.location_manager.requestAlwaysAuthorization()
                            self.location_manager.requestWhenInUseAuthorization()
                            
                            if (CLLocationManager.locationServicesEnabled()){
                                if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
                                    let location_last = self.location_manager.location
                                    let point = YMKPoint(latitude: Double((location_last?.coordinate.latitude)!), longitude: Double((location_last?.coordinate.longitude)!))
                                    
                                    location_map.mapWindow.map.move(
                                              with: YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0),
                                              animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.4),
                                              cameraCallback: nil)
                                }else{
                                    self.location_manager.requestAlwaysAuthorization()
                                    self.location_manager.requestWhenInUseAuthorization()
                                    
                                    ShowSettings(title: "Уведмоление", message: "Пожалуйста, включите геолокацию в настройках приложения Yelm Media")
                                }
                            }else{
                                self.location_manager.requestAlwaysAuthorization()
                                self.location_manager.requestWhenInUseAuthorization()
                                
                                ShowSettings(title: "Уведмоление", message: "Пожалуйста, включите геолокацию в настройках приложения Yelm Media")

                            }
                            
                           
                        }) {
                            VStack{
                                Image(systemName: "location.fill")
                                    .foregroundColor(.theme_foreground)
                                    
                                    
                            }
                                .frame(width: 15, height: 15)
                                .padding()
                                .background(Color.theme)
                                .clipShape(Circle())
                               
                        }.buttonStyle(ScaleButtonStyle())
                        
                    }
                }
                .padding([.bottom] , 10)
                .padding(.trailing, 10)
                
                HStack{
                   Spacer()
                    Button(action: {
                        
                        self.presentation.wrappedValue.dismiss()
                        self.location_update = false
                        
                        
                        self.realm.objectWillChange.send()
                        self.realm.post_location(Name: self.service.name, Point: self.service.point)
                        
                        self.realm.objectWillChange.send()
                        self.realm.get_locations()
                        
                        
                        
                        UserDefaults.standard.set(self.service.name, forKey: "SELECTED_SHOP_NAME")
                        UserDefaults.standard.set(self.service.point, forKey: "SELECTED_SHOP_POINTS")
                        
                        self.location.name = UserDefaults.standard.string(forKey: "SELECTED_SHOP_NAME") ?? "Выберите адрес"
                        self.location.point = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
                        
                        
                        
                        
                    }) {
                        HStack{
                            Spacer()
                            Text("Выбрать локацию")
                            Spacer()
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                    }.buttonStyle(ScaleButtonStyle())
                    Spacer()
                }
            }
            .padding(.bottom, 40)
            
            
        }
        
    }
}

