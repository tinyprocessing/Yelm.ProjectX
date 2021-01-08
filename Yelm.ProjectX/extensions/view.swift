//
//  view.swift
//  Yelm.ProjectX
//
//  Created by Michael on 08.01.2021.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func compatibleFullScreen<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(FullScreenModifier(isPresented: isPresented, builder: content))
    }
}

struct FullScreenModifier<V: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let builder: () -> V

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.fullScreenCover(isPresented: isPresented, content: builder)
        } else {
            content.sheet(isPresented: isPresented, content: builder)
        }
    }
}


func ShowAlert(title: String, message: String){
    
    UIApplication.shared.windows.first?.rootViewController?.present(alertView(title: title, message: message), animated: true)

}

private func alertView(title: String, message: String) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction (title: "Хорошо", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(okAction)
    
    return alert

}

func ShowSettings(title: String, message: String) {
    
    UIApplication.shared.windows.last?.rootViewController?.present(alertViewSettingsOpen(title: title, message: message), animated: true)
}

private func alertViewSettingsOpen(title: String, message: String) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction (title: "Закрыть", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(okAction)
    
    let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }

               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                       print("Settings opened: \(success)") // Prints true
                   })
               }
           }

    alert.addAction(settingsAction)
    return alert

}
