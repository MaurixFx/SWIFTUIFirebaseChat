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

    // MARK: - Main View
        var body: some View {
            NavigationView {
                VStack {
                    CustomNavBar(username: viewModel.chatUser?.email ?? "", imageURL: viewModel.chatUser?.profileImageUrl ?? "")
                    messagesView
                }
                .overlay(
                    newMessageButton, alignment: .bottom)
                .navigationBarHidden(true)
            }
        }

        private var messagesView: some View {
            ScrollView {
                ForEach(0..<10, id: \.self) { num in
                    VStack {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                )


                            VStack(alignment: .leading) {
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }

                            Spacer()

                            Text("22d")
                                .font(.system(size: 14, weight: .semibold))
                        }

                        Divider()
                            .padding(.vertical, 8)
                    }.padding(.horizontal)

                }.padding(.bottom, 50)
            }
        }

        private var newMessageButton: some View {
            Button {

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
        }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}


