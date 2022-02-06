//
//  MainMessagesViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 19-11-21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

final class MainMessagesViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    
    // MARK: - Init
    init() {
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    // MARK: - Fetch Current User
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
        }
    }
    
    // MARK: - Fetch Recents Messages
    private func fetchRecentMessages() {
        guard let currentUserUid = FirebaseManager.shared.auth.currentUser?.uid  else {
            return
        }
        
        self.recentMessages.removeAll()
        firestoreListener?.remove()
        
        firestoreListener = FirebaseManager.shared.firestore
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
                        return rm.id == documentId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }

                })
            }
    }

}
