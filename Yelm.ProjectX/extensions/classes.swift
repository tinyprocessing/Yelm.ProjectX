//
//  classes.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import Yelm_Server
import UIKit

var GlobalLoading: loading = loading()
var GlobalLocation: location_cache = location_cache()
var GlobalNotification: notification = notification()
var GlobalSearch: search = search()
var GlobalItems: items = items()
var GlobalNews: news = news()
var GlobalBottom: bottom = bottom()
var GlobalCart: cart = cart()
var GlobalWebview: loading_webview = loading_webview()


class bottom: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var hide : Bool = false
}


class loading_webview: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var height : CGFloat = 0.0
}

class loading: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var loading : Bool = false
}

class cart: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var cart_items : [cart_structure] = []
}

class items: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var item : items_structure = items_structure(id: 0)
}

class news: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var news : [news_structure] = []
    @Published var news_single : news_structure = news_structure(id: 0)
}

class search: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var items : [items_structure] = []
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
