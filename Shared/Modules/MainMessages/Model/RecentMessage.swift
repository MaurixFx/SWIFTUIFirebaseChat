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
    let email, text, fromId, toId, username, profileImageUrl: String
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
