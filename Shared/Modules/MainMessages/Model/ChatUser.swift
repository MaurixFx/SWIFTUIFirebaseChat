//
//  ChatUser.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 19-11-21.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatUser: Identifiable, Codable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl, username: String
}
