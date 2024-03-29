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
var GlobalPayment: payment = payment()
var GlobalOffer: offer = offer()
var GlobalCamera: camera = camera()
var GlobalVideo: video = video()
var GlobalConfetti: confetti = confetti()
var GlobalPromocode: promocode = promocode()
var GlobalCategories: categories = categories()
var GlobalCutlery: cutlery = cutlery()
var GlobalBadge: chat_badge = chat_badge()
var GlobalImageView: image_view = image_view()
var GlobalNotificationOpen: notification_open = notification_open()
var GlobalNotificationBanner: notification_banner = notification_banner()

var GlobalWebview: loading_webview = loading_webview()


var GlobalUserAuth: user_auth = user_auth()

class user_auth: ObservableObject, Identifiable {
    var id: Int = 0
    @Published var name : String = ""
    @Published var balance : Int = 0
    @Published var auth : Bool = false
    
    @Published var notifications : Bool = false
}

class image_view: ObservableObject, Identifiable {
    var id: Int = 0
    @Published var image : String = ""
    @Published var show : Bool = false
}

class chat_badge: ObservableObject, Identifiable {
    var id: Int = 0
    var count : Int = 0
}

class cutlery: ObservableObject, Identifiable {
    var id: Int = 0
    var count : Int = 1
}

class categories: ObservableObject, Identifiable {
    var id: Int = 0
    @Published var all : [categories_local_structure] = []

}


class notification_open: ObservableObject, Identifiable {
    var id: Int = 0
    @Published var key : String = ""
    @Published var value : Int = 0
}


class promocode: ObservableObject, Identifiable {
    var id: Int = 0
    @Published var active : promocode_structure = promocode_structure(id: 0, type: .nonactive, value: 0)
}


class notification_banner: ObservableObject, Identifiable {
    var id: Int = 0
    @Published var show : Bool = false
    @Published var title : String = ""
    @Published var text : String = ""
}

class confetti: ObservableObject, Identifiable{
    var id : Int = 0
    
    @Published var object: String = "😂"
}



class video: ObservableObject, Identifiable{
    var id : Int = 0
    
    @Published var play: Bool = false
}


class camera: ObservableObject, Identifiable{
    var id : Int = 0
    
    @Published var open: Bool = false
}


class offer: ObservableObject, Identifiable{
    
    var id : Int = 0
    
    @Published var promocode: String = ""
    @Published var entrance: String = ""
    @Published var floor: String = ""
    @Published var apartment: String = ""
    @Published var phone: String = ""
    
    @Published var bonus: Float = 0
    
    
}

class payment: ObservableObject, Identifiable {
    var id : Int = 0
    @Published var payment_done : Bool = false
    @Published var transaction : String = ""
    @Published var message : String = ""
    @Published var payment_free : Bool = false
}


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

public class items: ObservableObject, Identifiable {
    
    internal init(id: Int = 0, item: items_structure = items_structure()) {
        self.id = id
        self.item = item
    }
    
    
    public var id : Int = 0
    @Published var item : items_structure
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

extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}
