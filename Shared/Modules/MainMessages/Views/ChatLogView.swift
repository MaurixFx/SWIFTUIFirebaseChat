//
//  ChatLogView.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 30-11-21.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    @ObservedObject var viewModel: ChatLogViewModel
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.viewModel = .init(chatUser: chatUser)
    }
    
    var body: some View {
        ZStack {
            messagesView
        }
        .navigationTitle(chatUser?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages) { message in
                    VStack {
                        if chatUser?.uid != message.fromID {
                            HStack {
                                Spacer()
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(.white)
                                        
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                        } else {
                            HStack {
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(.black)
                                        
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                
                                Spacer()
                            }
                        }
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
            TextField("Description", text: $viewModel.chatText, prompt: nil)
            
            Button {
                viewModel.handleSend()
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
        MainMessagesView()
    }
}
