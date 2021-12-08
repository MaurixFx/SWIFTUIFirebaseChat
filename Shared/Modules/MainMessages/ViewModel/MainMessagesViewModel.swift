//
//  MainMessagesViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 19-11-21.
//

import Foundation
import SwiftUI
import Firebase

final class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            errorMessage = "Could not find firebase uid"
            return
        }
        
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print(self.errorMessage)
            }
            
            guard let data = snapshot?.data() else {
                return
            }
            
            self.chatUser = ChatUser.init(data: data)
            self.errorMessage = ""
        }
    }
    
    private func fetchRecentMessages() {
        guard let currentUserUid = FirebaseManager.shared.auth.currentUser?.uid  else {
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(currentUserUid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Failed to get messages: \(error.localizedDescription)")
                    return
                }
                
                snapshot?.documentChanges.forEach({ change in
                    let documentId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == documentId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    self.recentMessages.insert(
                        .init(with: documentId, data: change.document.data()),
                        at: 0
                    )
                })
            }
    }

}
