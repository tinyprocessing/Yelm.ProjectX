//
//  structures.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import Photos
import SwiftUI

struct locations_structure: Identifiable, Hashable {
    var id: Int
    var name: String = ""
    var point: String = ""
}


struct cart_structure: Identifiable, Hashable {
    var id: Int
    var image: String = ""
    var title: String = ""
    var price: String = ""
    var price_float: Float = 0.0
    var count: Int = 0
    var type: String = ""
    var quantity: String = ""
}


struct images: Hashable {
    var id: Int
    var image : UIImage
    var selected : Bool
}

struct selected_images: Hashable{
    var id: Int
    var image : UIImage
}
