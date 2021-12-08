//
//  ChatLogViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 30-11-21.
//

import SwiftUI
import Firebase

final class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var messages = [Message]()
    @Published var reloadMessages = false
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    func handleSend() {
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        guard let toID = chatUser?.uid else {
            return
        }
        
        let messageData = ["fromID": fromID, "toID": toID, "text": self.chatText, "timeStamp": Timestamp()] as [String : Any]
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromID)
            .collection(toID)
            .document()
        setMessageData(with: document, data: messageData)
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages").document(toID)
            .collection(fromID)
            .document()
        setMessageData(with: recipientMessageDocument, data: messageData)
    }
    
    private func fetchMessages() {
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        guard let toID = chatUser?.uid else {
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .order(by: "timeStamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Failed to get messages: \(error.localizedDescription)")
                    return
                }

                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        self.messages.append(.init(data: change.document.data(), documentID: change.document.documentID))
                    }
                })
                
                DispatchQueue.main.async {
                    self.reloadMessages = true
                }
            }
    }
    
    private func setMessageData(with documentReference: DocumentReference, data: [String: Any]) {
        documentReference.setData(data) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            } else {
                self.reloadMessages = true
                print("Message was created successfully")
                self.persistRecentMessage()
            }
        }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else {
            return
        }

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        let toID = chatUser.uid
        
        let document = FirebaseManager.shared.firestore.collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toID)
        
        let data = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toID,
            "profileImageUrl": chatUser.profileImageUrl,
            "username": chatUser.username
        ] as [String: Any]
        
        document.setData(data) { error in
            if let error = error {
                print("Failed to persist recent messages: \(error.localizedDescription)")
                return
            }

            self.chatText = ""
            print("Message is saved in recent messages")
            
        }
    }
}
