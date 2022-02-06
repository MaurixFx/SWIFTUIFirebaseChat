//
//  UserListViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 30-11-21.
//

import SwiftUI

final class UsersListViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    // MARK: - Init
    init() {
        fetchAllUsers()
    }
    
    // MARK: - Fetch All Users
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                    }
                    
                })
            }
    }
}
