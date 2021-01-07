//
//  buttons.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import SwiftUI
import UIKit

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
