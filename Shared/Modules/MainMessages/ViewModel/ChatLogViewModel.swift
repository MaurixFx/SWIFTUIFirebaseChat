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
    var chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages() {
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        guard let toID = chatUser?.uid else {
            return
        }
        
        firestoreListener = FirebaseManager.shared.firestore
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
    
    func handleSend() {
        let text = chatText
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
        
        document.setData(messageData) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            } else {
                self.reloadMessages = true
                print("Message was created successfully")
                self.chatText = ""
                self.persistRecentMessage(text: text)
            }
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages").document(toID)
            .collection(fromID)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
                return
            }
        }
    }
    

    private func persistRecentMessage(text: String) {
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
            "text": text,
            "fromId": uid,
            "toId": toID,
            "profileImageUrl": chatUser.profileImageUrl,
            "username": chatUser.username,
            "email": chatUser.email
        ] as [String: Any]
        
        document.setData(data) { error in
            if let error = error {
                print("Failed to persist recent messages: \(error.localizedDescription)")
                return
            }

            print("Message is saved in recent messages")
        }
        
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            "timestamp": Timestamp(),
            "text": text,
            "fromId": uid,
            "toId": toID,
            "profileImageUrl": currentUser.profileImageUrl,
            "username": currentUser.username,
            "email": currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toID)
            .collection("messages")
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
}
