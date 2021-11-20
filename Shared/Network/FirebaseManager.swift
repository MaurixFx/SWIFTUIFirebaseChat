//
//  FirebaseManager.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 13-11-21.
//

import Foundation
import Firebase

final class FirebaseManager: NSObject {

    // MARK: - Properties
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}
