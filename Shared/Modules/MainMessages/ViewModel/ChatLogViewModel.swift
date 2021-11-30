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
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
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
    
    private func setMessageData(with documentReference: DocumentReference, data: [String: Any]) {
        documentReference.setData(data) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            } else {
                print("Message was created successfully")
            }
        }
    }
}
