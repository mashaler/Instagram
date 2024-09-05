//
//  Comment.swift
//  Instagram
//
//  Created by Rolva Mashale on 2024/09/06.
//

import Foundation

struct Comment {
    
    let user: User
    let text: String
    let uid: String

    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
}
