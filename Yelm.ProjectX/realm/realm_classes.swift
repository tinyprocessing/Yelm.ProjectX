//
//  realm_classes.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import RealmSwift


open class ItemRealm: Object {
    @objc dynamic var ID = 0
    @objc dynamic var Title = ""
    @objc dynamic var Price: Float = 0
    @objc dynamic var PriceItem: Float = 0
    @objc dynamic var Count = 0
    @objc dynamic var Thumbnail = ""
    @objc dynamic var ItemType = ""
    @objc dynamic var quantity = ""
    @objc dynamic var CanIncrement = ""
    @objc dynamic var Discount: Int = 0
}


open class LocationData: Object {
    @objc dynamic var ID = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var Point: String = ""
}

