//
//  ChatLogView.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 30-11-21.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    @State var chatText = ""
    
    var body: some View {
        messagesView
//        ZStack {
//
//            VStack {
//                Spacer()
//                chatBottomBar
//                    .background(Color.white)
//            }
//
//        }
        .navigationTitle(chatUser?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ForEach(0..<20) { num in
                    HStack {
                        Spacer()
                        HStack {
                            Text("FAKE TEST")
                                .foregroundColor(.white)
                                
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                   
                    
                    
                }
                
                HStack {
                    Spacer()
                }
             
            }
            .background(Color(.init(white: 0.92, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                chatBottomBar
                    .background(Color(.systemBackground)
                                    .ignoresSafeArea())
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            //TextEditor(text: $chatText)
            TextField("Description", text: $chatText, prompt: nil)
            Button {
                
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(8)

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["username": "Maurix", "uid": "N1fPrp3TaEfgIbKfUeYibk6uZDM2"]))
        }
    }
}
