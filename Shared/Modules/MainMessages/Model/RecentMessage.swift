//
//  RecentMessage.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 07-12-21.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, fromId, toId, username, profileImageUrl: String
    let timestamp: Date
}
