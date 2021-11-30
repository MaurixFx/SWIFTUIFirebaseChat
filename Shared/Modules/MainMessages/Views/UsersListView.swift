//
//  UsersListView.swift
//  SwiftUIFirebaseChat
//
//  Created by Mauricio Figueroa on 29-11-21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UsersListView: View {
    
    let didSelectNewUser: (ChatUser) -> Void
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = UsersListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 15) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                            
                            Text(user.username)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(.label))
                            
                            Spacer()
                        }
                        .padding([.horizontal, .top], 15)
                    }
                    
                    Divider()
                }
            }.navigationTitle("New message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }

                    }
                }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
