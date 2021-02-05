//
//  Realm.swift
//  Yelm 2.0
//
//  Created by Michael Safir on 20.05.2020.
//  Copyright © 2020 Recode Media. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI
import SwiftyJSON
import Yelm_Chat
import Yelm_Server

var GlobalRealm: RealmControl = RealmControl()

class RealmControl: ObservableObject, Identifiable {
    var id: Int = 0

    @ObservedObject var cart: cart = GlobalCart
    @Published var price: Float = 0
    
    
    let realm : Realm
    init() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
         realm = try! Realm()
    }

  
    

    func create_item_cart(ID: Int, Title: String, Price: Float, PriceItem: Float, Count: Int, Thumbnail: String, ItemType: String, Quantity: String, CanIncrement: String, Discount: Int = 0) {

        let order = ItemRealm()
        order.ID = ID
        order.Title = Title
        order.Price = Price
        order.PriceItem = PriceItem
        order.Count = Count
        order.Thumbnail = Thumbnail
        order.ItemType = ItemType
        order.quantity = Quantity
        order.CanIncrement = CanIncrement
        order.Discount = Discount

        try! realm.write {
            realm.add(order)
            get_total_price()
        }
        
        ServerAPI.orders.set_temporary_orders(item_id: ID, action: "Добавил товар", count: 1) { (load) in
            if (load){
                YelmChat.core.send(message: "/basket", type: "basket")
            }
        }
    }

    
    func get_ids() -> JSON {
        let realm = try! Realm()
        let objects = realm.objects(ItemRealm.self)
        var items : JSON = []
        if (objects.count > 0){
            for i in 0...objects.count - 1 {
                let item : JSON = [
                    "id" : objects[i].ID,
                    "count" : objects[i].Count
                ]
                
                items.arrayObject?.append(item)

                
            }
            
            return items

        }
        
        return JSON()
        
    }

    func get_total_price() {
        
        let realm = try! Realm()

        let objects = realm.objects(ItemRealm.self)
        
        var Price : Float = 0.0
            if (objects.count > 0){
                self.cart.cart_items.removeAll()
                for i in 0...objects.count - 1 {
                    
                    if (objects[i].Discount != 0){
                        
                        let sym = Float(objects[i].Discount) / 100
                        let disc = objects[i].Price * sym
                        let discount_final = objects[i].Price - disc

                        let final = discount_final
                        
                        Price += (final * Float(objects[i].Count))
                        
                        let quantity = String(Int(objects[i].quantity)!*objects[i].Count)
                        
                        self.cart.cart_items.append(cart_structure(id: objects[i].ID,
                                                                   image: objects[i].Thumbnail,
                                                                   title: objects[i].Title,
                                                                   price: "\(objects[i].Price)",
                                                                   price_float: (final * Float(objects[i].Count)),
                                                                   count: objects[i].Count,
                                                                   type: objects[i].ItemType,
                                                                   quantity: quantity))
                        
                      

                    }else{
                        Price += Float((Int(objects[i].Price) * objects[i].Count))
                        
                        let quantity = String(Int(objects[i].quantity)!*objects[i].Count)

                        self.cart.cart_items.append(cart_structure(id: objects[i].ID,
                                                                   image: objects[i].Thumbnail,
                                                                   title: objects[i].Title,
                                                                   price: "\(objects[i].Price)",
                                                                   price_float: Float((Int(objects[i].Price) * objects[i].Count)),
                                                                   count: objects[i].Count,
                                                                   type: objects[i].ItemType,
                                                                   quantity: quantity))
                    
                    }
            }
        }
        self.objectWillChange.send()
   

        
        self.price = Price
        
        
     
        
    }
    
 
  

    func get_items_realmtype() -> Results<ItemRealm> {
        let realm = try! Realm()
        let objects = realm.objects(ItemRealm.self)
        return objects
    }
    
    func clear_cart(order: Bool = false) {
        
        let realm = try! Realm()
        try! realm.write {
            let cart = realm.objects(ItemRealm.self)
            realm.delete(cart)
        }
        
        self.cart.cart_items.removeAll()
        self.get_total_price()
        
        if (order == false){
            
            ServerAPI.orders.set_temporary_orders(item_id: 0, action: "Очистил корзину", count: 0) { (load) in
                if (load){
                    YelmChat.core.send(message: "/basket", type: "basket")
                }
            }
            
        }
        
        if (order == true){
            
            ServerAPI.orders.set_temporary_orders(item_id: 0, action: "Создал заказ", count: 0) { (load) in
                if (load){
                    YelmChat.core.send(message: "/basket", type: "basket")
                }
            }
            
        }
      
        
    }

    func delete_item(ID: Int) {
        let realm = try! Realm()
        let object = realm.objects(ItemRealm.self).filter("ID = \(ID)")
        try! realm.write {
            realm.delete(object)
            get_total_price()
        }
        
        ServerAPI.orders.set_temporary_orders(item_id: ID, action: "Удалил товар", count: 0) { (load) in
            if (load){
                YelmChat.core.send(message: "/basket", type: "basket")
            }
        }
    }

    func get_item_realmtype(ID: Int) -> Results<ItemRealm> {
        let realm = try! Realm()
        let object = realm.objects(ItemRealm.self).filter("ID = \(ID)")
        return object
    }

  
    func post_cart(ID: Int, method: String) {
        
        let realm = try! Realm()
        let objects = realm.objects(ItemRealm.self).filter("ID = \(ID)")
        
        
        if (method == "increment"){
            
            if let object = objects.first {
                try! realm.write {
                    let new_count = object.Count + 1
                    object.Count = new_count
                    
                    ServerAPI.orders.set_temporary_orders(item_id: ID, action: "Увеличил товар", count: new_count) { (load) in
                        if (load){
                            YelmChat.core.send(message: "/basket", type: "basket")
                        }
                    }
                    
                    get_total_price()
                }
                
              
            }
            
        }
        
        if (method == "decrement"){
            
            if let object = objects.first {
                if (object.Count > 1){
                    try! realm.write {
                        let new_count = object.Count - 1
                        object.Count =  new_count
                        
                        ServerAPI.orders.set_temporary_orders(item_id: ID, action: "Уменьшил товар", count:  new_count) { (load) in
                            if (load){
                                YelmChat.core.send(message: "/basket", type: "basket")
                            }
                        }
                        
                        get_total_price()
                    }
                   
                }else{
                    self.delete_item(ID: ID)
                  
                }
            }
            
        }
    }
    
    func get_items_count(ID: Int) -> Int {
        let realm = try! Realm()
        let objects = realm.objects(ItemRealm.self).filter("ID = \(ID)")
        
        if let object = objects.first {
            return object.Count
        }
        
        return 0
    }
    
    func get_item_access(ID: Int) -> Bool {
        
        let show_items = self.get_items_count(ID: ID)

        if show_items > 0{
            return true
        }else{
            return false
        }
    }

}
