//
//  classes.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation


var GlobalLoading: loading = loading()
var GlobalLocation: location_cache = location_cache()
var GlobalNotification: notification = notification()

class loading: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var loading : Bool = false
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
