//
//  shapes.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import UIKit
import SwiftUI


struct CustomShape: Shape {

    var corner: UIRectCorner
    var radii: CGFloat

    func path(in rect: CGRect) -> Path {

        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))

        return Path(path.cgPath)
    }
}
