//
//  chat_classes.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import SwiftUI
import Combine

var GlobalChat: chat = chat()

class chat: ObservableObject, Identifiable{

    var chatName: String = ""

    @Published var user : String = ""
    @Published var keyboardHeight: CGFloat = 0

    init() {
        self.user = UserDefaults.standard.string(forKey: "USER") ?? ""
        print(user)
        print("user up")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
}
