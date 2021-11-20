//
//  MainMessagesViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 19-11-21.
//

import Foundation
import SwiftUI

final class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init() {
        fetchCurrentUser()
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
}
