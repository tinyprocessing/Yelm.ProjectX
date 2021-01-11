//
//  Home.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server



struct Home: View {
    
    @ObservedObject var location : location_cache = GlobalLocation
    @ObservedObject var modal : ModalManager = GlobalModular
    @ObservedObject var loading: loading = GlobalLoading
    @Binding var items : [items_main_cateroties]
    @State var selection: Int? = nil
    @State private var isAnimating = false
    
    
    func width(y: CGFloat) -> CGFloat {
        let screen = CGFloat(UIScreen.main.bounds.width-90)
        let header: CGFloat = 47
        let width = (screen)-pow(((y-header)*0.01+1.2), 6.995)
        
        if (width <= 40){
            if (self.loading.loading == false){
                self.loading.objectWillChange.send()
                self.loading.loading = true
                ServerAPI.items.get_items { (ready, items) in
                    
                    if (ready){
                        
                        self.items = items
                        
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                            withAnimation{
                                self.loading.loading = false
                            }
                        }
                    }
                    
                }
            }
            return 40.0
        }
        
        return width
    }
    
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                VStack{
                    Color.white
                }.frame(width: UIScreen.main.bounds.width, height: 0)
                .offset(y: -5)
                
                ScrollView(showsIndicators: false) {
                    
                    
                    
                    GeometryReader{ geo -> AnyView in
                        
                        
                        return AnyView(
                            
                            HStack{
                                
                                NavigationLink(destination: Search(), tag: 3, selection: $selection) {
                                    HStack{
                                        Image(systemName: "magnifyingglass").font(.system(size: 18, weight: .medium, design: .rounded))
                                    }
                                }.buttonStyle(ScaleButtonStyle())
                                
                                Spacer()
                                
                                
                                Button(action: {
//                                    Open modal with locations
                                    
                                    self.modal.newModal(position: .closed) {
                                        ModalLocation()
                                            .clipped()
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                                        self.modal.openModal()
                                    }
                                    
                                }) {
                                    
                                    
                                    
                                    VStack(alignment: .center){
                                        
                                        if (self.loading.loading){
                                            
                                            
                                            Image(systemName: "arrow.2.circlepath")
                                                .foregroundColor(.white)
                                                .transition(.opacity)
                                                
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                                                .animation(self.isAnimating ? forever : .default)
                                                .onAppear { self.isAnimating = true }
                                                .onDisappear { self.isAnimating = false }
                                            
                                            
                                            
                                            
                                        }else{
                                            ZStack(alignment: .center){
                                                Text(" \(self.location.name) ")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .opacity(Double((width(y: geo.frame(in: .global).minY)-110) * 0.01))
                                                
                                                if (Double((width(y: geo.frame(in: .global).minY)-110) * 0.01) < 0.6){
                                                    Image(systemName: "arrow.2.circlepath")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                                        .transition(.opacity)
                                                        
                                                        .opacity(1.0-Double((width(y: geo.frame(in: .global).minY)-110) * 0.01))
                                                }
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                    .frame(width: self.loading.loading == false ? (geo.frame(in: .global).minY <= 43.5 ? UIScreen.main.bounds.width-90 : width(y: geo.frame(in: .global).minY)) : 40)
                                    .frame(height: 40)
                                    .transition(.slide)
                                    .background(Color.theme)
                                    .cornerRadius(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            
                                            .fill(Color.neuBackground)
                                            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                                            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                                        
                                    )
                                    
                                }.buttonStyle(ScaleButtonStyle())
                                Spacer()
                                
                                NavigationLink(destination: Chat(), tag: 2, selection: $selection) {
                                    ZStack(alignment: .top){
                                        HStack{
                                            Image(systemName: "bubble.left").font(.system(size: 18, weight: .medium, design: .rounded))
                                        }
                                        .overlay(
                                            ZStack{
                                                Circle()
                                                    .foregroundColor(.red)
                                                    .frame(width: 15, height: 15)
                                                
                                                Text("!")
                                                    .foregroundColor(.white)
                                                    .font(Font.system(size: 11))
                                            }.offset(x: 12, y: -11)
                                        )
                                        
                                        
                                    }
                                }.buttonStyle(ScaleButtonStyle())
                                
                            }.frame(width: UIScreen.main.bounds.width-30)
                            
                        )
                        
                    }
                    .frame(width: UIScreen.main.bounds.width-30)
                    .frame(height: 50)
                    
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(self.items, id: \.self) { object in
                            ItemsViewLine(items: object.items, name: object.name)
                        }
                        
                        
                        Spacer(minLength: 150)
                    }
                    
                }
            }
            
        }
    }
}
