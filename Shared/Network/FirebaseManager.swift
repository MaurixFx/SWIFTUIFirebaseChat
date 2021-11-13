//
//  FirebaseManager.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 13-11-21.
//

import Foundation
import Firebase

final class FirebaseManager: NSObject {

    let auth: Auth
    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
}
