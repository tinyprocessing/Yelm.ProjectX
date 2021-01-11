//
//  chat_structures.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation

struct chat_message: Identifiable, Hashable {
    var id: Int
    var user: chat_user = chat_user(id: 0)
    var text: String = ""
    var time: String = ""
    var date: String = ""
    var attachments: [String : String] = [:]
}


struct chat_user: Identifiable, Hashable {
    var id: Int
    var name: String = ""
    var online: String = ""
}
