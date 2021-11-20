//
//  SwiftUIFirebaseChatApp.swift
//  Shared
//
//  Created by Mauricio Figueroa on 13-11-21.
//

import SwiftUI

@main
struct SwiftUIFirebaseChatApp: App {
    
    @ObservedObject var loginState = LoginState()
    
    var body: some Scene {
        WindowGroup {
            if loginState.isLogged {
                MainMessagesView()
                    .environmentObject(loginState)
            } else {
                LoginView()
                    .environmentObject(loginState)
            }
        }
    }
}

final class LoginState: ObservableObject {
    @Published var isLogged = false
    
    init() {
        self.isLogged = FirebaseManager.shared.auth.currentUser?.uid != nil
    }
}
