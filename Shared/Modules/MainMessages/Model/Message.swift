//
//  Message.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 30-11-21.
//

import Foundation
import Firebase

struct Message: Identifiable {
    var id: String {
        documentID
    }
    
    let fromID: String
    let toInt: String
    let text: String
    let date: Timestamp
    let documentID: String
    
    init(data: [String: Any], documentID: String) {
        self.documentID = documentID
        self.fromID = data["fromID"] as? String ?? ""
        self.toInt = data["toInt"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.date = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
}
