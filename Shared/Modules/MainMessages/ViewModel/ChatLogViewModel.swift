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
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        getMessages()
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
        setMessageData(with: recipientMessageDocument, data: messageData, isRecipient: true)
    }
    
    func getMessages() {
        if let fromID = FirebaseManager.shared.auth.currentUser?.uid,
            let toID = chatUser?.uid  {
            self.messages.removeAll()
            fetchMessages(from: fromID, to: toID)
            fetchMessages(from: toID, to: fromID)
        }
    }
    
    private func fetchMessages(from fromID: String, to toID: String) {
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .whereField("fromID", isEqualTo: fromID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Failed to get messages: \(error.localizedDescription)")
                    return
                }

                snapshot?.documents.forEach({ snapshot in
                    self.messages.append(.init(data: snapshot.data()))
                })
                
                self.messages = self.messages.sorted {
                    $0.date.dateValue() < $1.date.dateValue()
                }
            }
    }
    
    private func setMessageData(with documentReference: DocumentReference, data: [String: Any], isRecipient: Bool = false) {
        documentReference.setData(data) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            } else {
                print("Message was created successfully")
                self.chatText = ""
                
                // When we saved the recipient means is the last save process, so we can update the messages
                if isRecipient {
                    self.getMessages()
                }
            }
        }
    }
}
