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

    
    @Published var messages : [chat_message] = [
        chat_message(id: 1, user: chat_user(id: 0, name: "user16", online: ""), text: "Добрый день, подскажите пожалуйста есть ли сыр в продаже головками?", time: "12:00", attachments: [:]),
        chat_message(id: 2, user: chat_user(id: 1, name: "shop", online: ""), text: "Да, конечно!", time: "12:01", attachments: [:]),
        chat_message(id: 3, user: chat_user(id: 1, name: "shop", online: ""), text: "", time: "12:04",
                     attachments: ["image" : "https://avatars.mds.yandex.net/get-eda/3682162/00c405007ab3e1be279544a8eabd0673/1200x1200"])]
    
    
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
