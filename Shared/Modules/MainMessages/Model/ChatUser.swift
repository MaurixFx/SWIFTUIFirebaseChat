//
//  ChatUser.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 19-11-21.
//

import Foundation

struct ChatUser: Identifiable {

    var id: String { uid }
    let uid: String
    let email: String
    let profileImageUrl: String
    let username: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
}
