//
//  MainMessagesView.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 19-11-21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessagesView: View {
    
    @ObservedObject private var viewModel = MainMessagesViewModel()
    @EnvironmentObject var state: LoginState
    @ObservedObject private var navBarViewModel = CustomNavBarViewModel()
    
    @State var shouldShowLogOutOptions = false
    @State var shouldShowNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false
    
    private var chatViewModel = ChatLogViewModel(chatUser: nil)
    
    // MARK: - Main View
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messagesView
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(viewModel: chatViewModel)
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        
        HStack(spacing: 16) {
            WebImage(url: URL(string: viewModel.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.chatUser?.username ?? "")")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    navBarViewModel.handleSignOut(state: state)
                }),
                .cancel()
            ])
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(viewModel.recentMessages) { recentMessage in
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                        
                        self.chatUser = .init(
                            id: uid,
                            uid: uid,
                            email: recentMessage.email,
                            profileImageUrl: recentMessage.profileImageUrl,
                            username: recentMessage.username
                        )
                        
                        self.chatViewModel.chatUser = self.chatUser
                        self.chatViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.username)
                                    .font(.system(size: 16, weight: .bold))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color(.label))

                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(3)
                            }
                            
                            Spacer()
                            
                            Text(recentMessage.timeAgo)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                    }

                    Divider()
                    .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            UsersListView(didSelectNewUser: { user in
                self.chatUser = user
                print(user.email)
                self.shouldNavigateToChatLogView.toggle()
                self.chatViewModel.chatUser = user
                self.chatViewModel.fetchMessages()
            })
        }
    }
    
    @State var chatUser: ChatUser?
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}


