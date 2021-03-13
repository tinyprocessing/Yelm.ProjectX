//
//  rating.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 10.03.2021.
//

import Foundation
import StoreKit

enum AppStoreReviewManager {
  static func requestReviewIfAppropriate() {
        
        let region = UserDefaults.standard.integer(forKey: "rating")
        print(region)
        if (region % 10 == 0 && region != 0){
            SKStoreReviewController.requestReview()
        }
        UserDefaults.standard.set(region+1, forKey: "rating")

  }
}
