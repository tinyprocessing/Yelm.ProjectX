//
//  classes.swift
//  Yelm.ProjectX
//
//  Created by Michael on 08.01.2021.
//

import Foundation


var GlobalMapService: MapService = MapService()


/// Map Service Class helps react get point and check searching state
open class MapService: ObservableObject, Identifiable {
    public var id: Int = 0
    public var name: String = ""
    public var found: Bool = false
    public var point: String = ""
}
