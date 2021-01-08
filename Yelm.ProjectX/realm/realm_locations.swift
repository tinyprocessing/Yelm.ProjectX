//
//  realm_locations.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import RealmSwift



var GlobalRealmLocations: RealmLocations = RealmLocations()

class RealmLocations: ObservableObject, Identifiable {
    var id: Int = 0
    
    @Published var locations : [locations_structure] = []
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
    
    
    
    func post_location(Name: String, Point: String) {
        let location = LocationData()
        location.ID = increment_location()
        location.Name = Name
        location.Point = Point
        
        try! realm.write {
            realm.add(location)
        }
        
    }
    
    func get_locations() {
        let realm = try! Realm()
        let objects = realm.objects(LocationData.self)
        
        if (objects.count > 0) {
            self.objectWillChange.send()
            self.locations.removeAll()
            for i in 0...objects.count - 1 {
                self.objectWillChange.send()
                
                self.locations.append(locations_structure(id: objects[i].ID, name: objects[i].Name, point: objects[i].Point))
                
                
            }
        }else{
            self.locations.removeAll()
        }
        
    }
    
    func increment_location() -> Int {
        return (realm.objects(LocationData.self).max(ofProperty: "ID") as Int? ?? 0) + 1
    }
    
    func delete_location(ID: Int) {
        print(ID)
        let realm = try! Realm()
        let object = realm.objects(LocationData.self).filter("ID = \(ID)")
        try! realm.write {
            realm.delete(object)
        }
        self.get_locations()
    }
    
    
    
}
