//
//  func.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 09.03.2021.
//

import Foundation
import Yelm_Server
import SwiftUI

func region_change() {
    
    let region = UserDefaults.standard.string(forKey: "region") ?? ""
    let region_current = Locale.current.regionCode
    if (region != region_current){
        GlobalRealm.clear_cart()
    }
    
    if (Locale.current.regionCode != nil){
        UserDefaults.standard.set(Locale.current.regionCode, forKey: "region")
    }
    
}
