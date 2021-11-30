//
//  UserListViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 30-11-21.
//

import SwiftUI

final class UsersListViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        guard let currentUid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        FirebaseManager.shared.firestore.collection("users")
            .whereField("uid", isNotEqualTo: currentUid)
            .getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print(self.errorMessage)
                return
            }
            
            snapshot?.documents.forEach({ snapshot in
                self.users.append(.init(data:  snapshot.data()))
            })
            
            self.errorMessage = "Fetch users successfully"
        }
    }
}
