//
//  History.swift
//  Yelm.ProjectX
//
//  Created by Michael on 04.02.2021.
//

import SwiftUI
import Foundation
import Yelm_Server
import YandexMapKit


struct History: View {
    
    
    @State var history_object : orders_history_structure = orders_history_structure(id: 0)
    
    @State var nav_bar_hide: Bool = true
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var items : [items_structure] = []
    @State var selection: Int? = nil
    @State var color = 0
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    @State var show : Float = 0.0
    
    @State var id_order : String = ""
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var status: loading_webview = GlobalWebview
    
    @Environment(\.presentationMode) var presentation
    
    
    
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var opacity : Double = 0
    
    @State var location_map : YMKMapView = YMKMapView()
    @State var location_update : Bool = false
    
    @State var point : YMKPoint = YMKPoint(latitude: 55.751244, longitude: 37.618423)
    
    var body: some View{
        
        ZStack(alignment: .bottom){
            ZStack(alignment: .top){
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            
                            // First Parallax Scroll...
                            
                            GeometryReader{reader in
                                
                                VStack{
                                    
                                    
                                    
                                        ZStack{
                                            
                                            MapHistory(YandexMap: $location_map, location_update_allow: $location_update, point: $point)
                                                .frame(width: UIScreen.main.bounds.width+20,
                                                       height: reader.frame(in: .global).minY > 0 ? CGFloat(Int(reader.frame(in: .global).minY + 296)) : 296)
                                                .offset(y: -reader.frame(in: .global).minY)
                                            
                                            ZStack{
                                                
                                                Image("map_pin")
                                                    .resizable()
                                                    .frame(width: 60, height: 60)
                                                    .offset(y: 35-reader.frame(in: .global).minY)
                                                
                                        }
                                        .offset(y: -70)
                                            
                                        }
                                        
                                        
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                            // setting default height...
                            .frame(height: 250)
                            
                            // List Of Songs...
                            
                            VStack(spacing: 5){
                                
                                
                                if (true){
                                    
                                    GeometryReader{g in
                                        VStack{
                                            Text("")
                                        }
                                        .onReceive(self.time) { (_) in
                                            
                                            
                                            if (g.frame(in: .global).minY < 80){
                                                withAnimation{
                                                    self.show = 1.0
                                                }
                                            }else{
                                                withAnimation{
                                                    self.show = 0.0
                                                }
                                            }
                                        }
                                    } .frame(height: 0)
                                    
                                    HStack {
                                        
                                        
                                        Text("\(self.history_object.transaction_status)")
                                            .font(.title)
                                            .foregroundColor(Color.green)
                                            .fontWeight(.bold)
                                        
                                        
                                        Spacer()
                                        
                                        
                                        
                                    }
                                    .padding(.horizontal, 15)
                                    
                                    
                                }
                                
                                
                                
                                HStack{
                                    Text("""
                                    № \(self.id_order)
                                    Сумма заказа:  \( String(format:"%.2f", self.history_object.end_total)) \(ServerAPI.settings.symbol)
                                    Дата создания: \(self.history_object.created_at)
                                    Адрес: \(self.history_object.address)

                                    Пожалуйста, оцените товары, которые Вам понравились или разочаровали, мы рады становиться лучше для Вас с каждым отзывом, Спасибо!
                                    """)
                                        .foregroundColor(Color.secondary)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .padding(.horizontal, 15)
                                        .padding(.top, 5)
                                    
                                    Spacer()
                                }
                                
                                
                                VStack(alignment: .leading, spacing: 5){
                                    
                                    ForEach(self.history_object.items, id: \.self){ item in
                                        history_item(item: item)
                                    }
                                    
                                }
                                .padding(10)
                                
                                .background(Color.theme_black_change_reverse)
                                .clipShape(CustomShape(corner: .allCorners, radii: 10))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                
                                .padding(.horizontal, 15)
                                .padding(.top, 5)
                                
                                
                             
                                
                                Button(action: {

                                    if let url = URL(string: self.history_object.ofd) {
                                        UIApplication.shared.open(url)
                                    }
                                    
                                }) {
                                    Text("Чек покупки")
                                        .padding(.horizontal, 10)
                                        .foregroundColor(.theme)
                                        .padding(.top, 15)
                                }.buttonStyle(ScaleButtonStyle())

                                Spacer(minLength: 70)
                                
//                                Button(action: {
//
//                                }) {
//                                    HStack{
//
//                                        Text("Повторить?")
//                                            .padding(.horizontal, 10)
//
//                                    }
//                                    .padding(.horizontal)
//                                    .padding(.vertical, 10)
//                                    .background(Color.theme)
//                                    .foregroundColor(.theme_foreground)
//                                    .cornerRadius(10)
//                                    .padding(.top, 15)
//                                }.buttonStyle(ScaleButtonStyle())
//
//
                                
//                                Spacer(minLength: UIScreen.main.bounds.height)
                                
                                
                            }
                            .padding(.vertical)
                            .background(Color.theme_black_change_reverse)
                            .cornerRadius(40)
                            
                            
                        } .background(Color.theme_black_change_reverse)
                    }
                    
                }
                
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
                        .buttonStyle(ScaleButtonStyle())
                        
                        
                        
                        Spacer()
                        
                        if (self.show == 1.0){
                            Text("История заказов")
                                .padding(.top, 10)
                                .offset(x: -15)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                        }
                        
                        
                        
                        
                        Spacer()
                        
                        
                        
                        
                        
                        
                    }
                    .padding(.top, (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
                    .padding([.trailing, .leading], 20)
                    .padding(.bottom, 10)
                    .background(self.show == 1.0 ? Color.theme_black_change_reverse : Color.clear)
                }
                
            }
            
            
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
        
        .onAppear {
            self.bottom.hide = true
            self.nav_bar_hide = true
            
            
            ServerAPI.orders.get_order_history(id: self.id_order) { (load, object)  in
                if (load){
                    self.history_object = object
                    
                    self.point = YMKPoint(latitude: Double(object.latitude)!, longitude: Double(object.longitude)!)
                    
                    location_map.mapWindow.map.move(
                              with: YMKCameraPosition(target: self.point, zoom: 15, azimuth: 0, tilt: 0),
                              animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.4),
                              cameraCallback: nil)
                }
            }
            print("order_id - \(self.id_order)")
        }
        
        .onDisappear{
            
            if (open_item == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }else{
                open_item = false
            }
        }
    }
    
    
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
