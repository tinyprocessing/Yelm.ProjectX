//
//  classes.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import Yelm_Server

var GlobalLoading: loading = loading()
var GlobalLocation: location_cache = location_cache()
var GlobalNotification: notification = notification()
var GlobalItems: items = items()
var GlobalBottom: bottom = bottom()


class bottom: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var hide : Bool = false
}

class loading: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var loading : Bool = false
}

class items: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var item : items_structure = items_structure(id: 0)
}

class notification: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var token : String = ""
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


class location_cache: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var point : String = ""
    @Published var name : String = ""
}
