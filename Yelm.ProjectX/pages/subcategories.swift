//
//  subcategories.swift
//  Yelm.ProjectX
//
//  Created by Michael on 19.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server


struct Subcategories : View {
    
    
    
    @ObservedObject var item: items = GlobalItems
    @ObservedObject var bottom: bottom = GlobalBottom
    @State var nav_bar_hide: Bool = true
    @Environment(\.presentationMode) var presentation
    @ObservedObject var realm: RealmControl = GlobalRealm
    @State var selection: Int? = nil
    
    @State var name : String = ""
    @State var search : String = ""
    
    
    @State var items : [items_main_cateroties] = []
    
    var body: some View{
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
                    
                    Text("\(self.name)")
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
            
            //            Items show grid
            
            
            //self.search_server.items.filter { $0.title.lowercased().contains(search.lowercased()) ||
            ScrollView(showsIndicators: false){
                
                SearchBar(text: $search)
                    .padding(.bottom)
                    .padding(.horizontal, -30)
                
                ForEach(self.items.filter { $0.items.contains(where: { $0.title.lowercased().contains(search.lowercased()) }) || search.isEmpty }, id: \.self){ object in
                    
                    VStack{
                        HStack(alignment: .center) {
                            Text(object.name)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                            if (object.items.filter{$0.discount_present != "-0%"}.count > 0){
                                
                                Text("%")
                                    .foregroundColor(Color.white)
                                    .frame(width: 16, height: 16, alignment: .center)
                                    .padding([.top, .leading, .bottom, .trailing], 5)
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                                    .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                            }
                            
                            Spacer()
                            
                            
                        }.frame(width: UIScreen.main.bounds.width-30)
                        .padding(.bottom, 15)
                        // grid
                        
                        SubcategoriesGrid(items: object.items, search: $search)
                    }
                    
                }
                
            }.frame(width: UIScreen.main.bounds.size.width-30)
            
            
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
            
            ServerAPI.items.get_items { (load, items) in
                if (load){
                    
                    self.items = items
                }
            }
        }
        
        .onDisappear{
            if (open_item == false){
                self.bottom.hide = false
            }
        }
        
    }
}
