//
//  CustomNavBar.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 19-11-21.
//

import SwiftUI

final class CustomNavBarViewModel: ObservableObject {
    
    init() {}
    
    func handleSignOut(state: LoginState) {
        do {
            try FirebaseManager.shared.auth.signOut()
            state.isLogged = false
        } catch {
            print(error)
        }
    }
}
