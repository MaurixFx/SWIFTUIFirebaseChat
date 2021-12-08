//
//  RecentMessage.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 07-12-21.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable {
    var id: String {
        documentId
    }
    
    let documentId: String
    let text, fromId, toId, username, profileImageUrl: String
    let timestamp: Timestamp
    
    init(with documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.timestamp = data["profileImageUrl"] as? Timestamp ?? Timestamp(date: Date())
    }
}
