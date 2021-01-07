//
//  gestures.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON


class AnyGestureRecognizer: UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}
