//
//  User.swift
//  Instagram
//
//  Created by Rolva Mashale on 2024/09/06.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    let bio: String
    var followingCount: Int
    var followersCount: Int
    var postsCount: Int

    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        bio = dictionary["bio"] as? String ?? ""
        followingCount = dictionary["followingCount"] as? Int ?? 0
        followersCount = dictionary["followersCount"] as? Int ?? 0
        postsCount = dictionary["postsCount"] as? Int ?? 0
    }

}
