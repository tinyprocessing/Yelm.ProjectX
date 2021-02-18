//
//  subcategoies_grid.swift
//  Yelm.ProjectX
//
//  Created by Michael on 20.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server
import Grid


struct SubcategoriesGrid : View {
    
    
    @ObservedObject var item: items = GlobalItems
    @ObservedObject var realm: RealmControl = GlobalRealm
    
    @State var items : [items_structure] = []
    @State var selection: Int? = nil
    
    @Binding var search : String
    
    var body: some View{
        VStack{
            
            Grid(self.items.filter { $0.title.lowercased().contains(search.lowercased()) ||  search.isEmpty} , id: \.self) { tag in
                
                NavigationLink(destination: Item(), tag: 4, selection:  $selection){
                    
                    SubcategoriesGridObject(tag: tag)
                    
                }
                .buttonStyle(ScaleButtonStyle())
                .simultaneousGesture(TapGesture().onEnded{
                    ServerAPI.settings.log(action: "open_item_subcategory", about: "\(tag.id)")
                    open_item = true
                    let item = tag
                    self.item.item = item
                })
                
                
            }.gridStyle(
                //.frame(width: 180, height: 245)
                ModularGridStyle(columns: 2, rows: .fixed(300))
            )
            
        }
        
    }
    
}
