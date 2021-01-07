//
//  Realm.swift
//  Yelm 2.0
//
//  Created by Michael Safir on 20.05.2020.
//  Copyright © 2020 Recode Media. All rights reserved.
//

import Foundation
import RealmSwift

var GlobalRealm: RealmControl = RealmControl()

class RealmControl: ObservableObject, Identifiable {
    var id: Int = 0


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
    }


    func get_total_price() {
        
        let realm = try! Realm()
        let objects = realm.objects(ItemRealm.self)
        
        var Price : Float = 0.0
            if (objects.count > 0){
                for i in 0...objects.count - 1 {
                    
                    if (objects[i].Discount != 0){
                        
                        let sym = Float(objects[i].Discount) / 100
                        let disc = objects[i].Price * sym
                        let discount_final = objects[i].Price - disc

                        let final = discount_final
                        
                        Price += (final * Float(objects[i].Count))
                        
                      

                    }else{
                        Price += Float((Int(objects[i].Price) * objects[i].Count))
                    
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

    func delete_item(ID: Int) {
        let realm = try! Realm()
        let object = realm.objects(ItemRealm.self).filter("ID = \(ID)")
        try! realm.write {
            realm.delete(object)
            get_total_price()
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
                    object.Count = (object.Count + 1)
                    get_total_price()
                }
                
              
            }
            
        }
        
        if (method == "decrement"){
            
            if let object = objects.first {
                if (object.Count > 1){
                    try! realm.write {
                        object.Count = (object.Count - 1)
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
