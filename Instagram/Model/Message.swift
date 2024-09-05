//
//  Message.swift
//  Instagram
//
//  Created by Rolva Mashale on 2024/09/06.
//

import Foundation

struct Message {
    var fromId: String
    var text: String
    var toId: String
    var timeStamp: Double
    
    init(dictionary: [String: Any]) {
        fromId = dictionary["fromId"] as? String ?? ""
        text = dictionary["text"] as? String ?? ""
        toId = dictionary["toId"] as? String ?? ""
        timeStamp = dictionary["timeStamp"] as? Double ?? 0
    }
    
}
