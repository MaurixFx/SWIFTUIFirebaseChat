//
//  ChatLogView.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 30-11-21.
//

import SwiftUI

struct ChatLogView: View {
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    var body: some View {
        ZStack {
            messagesView
        }
        .navigationTitle(viewModel.chatUser?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.firestoreListener?.remove()
        }
        
    }
    
    let scrollId = "Empty"
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                        }
                        
                        HStack {
                            Spacer()
                        }
                        .id(self.scrollId)
                    }
                    .onReceive(viewModel.$reloadMessages) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(
                                self.scrollId,
                                anchor: .bottom
                            )
                        }
                    }
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
    
    struct MessageView: View {
        
        let message: Message
        
        var body: some View {
            VStack {
                if message.fromID == FirebaseManager.shared.auth.currentUser?.uid {
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
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $viewModel.chatText)
                    .opacity(viewModel.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                viewModel.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(
                viewModel.chatText.isEmpty ? Color(.init(white: 0.7, alpha: 1)) : Color.blue
            )
            .cornerRadius(8)
            .disabled(viewModel.chatText.isEmpty)

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
