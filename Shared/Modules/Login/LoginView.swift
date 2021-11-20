//
//  ContentView.swift
//  Shared
//
//  Created by Mauricio Figueroa on 13-11-21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var username = ""
    @State var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3)
                            )
                        }
                    }
                    
                    Group {
                        if !isLoginMode {
                            TextField("Username", text: $username)
                            .autocapitalization(.none)
                        }
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                        
                    }
                    
                    Text(loginStatusMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginStatusMessage = "failed to login user: \(error.localizedDescription)"
                print(loginStatusMessage)
                return
            }
            
            guard let user = result?.user else {
                return
            }
            
            self.loginStatusMessage = "Successfully login user: \(user.uid)"
            print(self.loginStatusMessage)
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.loginStatusMessage = "failed to create user: \(error.localizedDescription)"
                print(loginStatusMessage)
                return
            }
            
            guard let user = authResult?.user else {
                return
            }
            
            self.loginStatusMessage = "Successfully created user: \(user.uid)"
            print(self.loginStatusMessage)
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        ref.putData(imageData, metadata: nil) { meta, error in
            if let error = error {
                self.loginStatusMessage = "Failed to push image to Storage:  \(error.localizedDescription)"
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    self.loginStatusMessage = "Failed to retrieve downloadURL:  \(error.localizedDescription)"
                    return
                }
                
                self.loginStatusMessage = "Successfuly stored image with url: \(url?.absoluteString ?? "")"
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString, "username": username]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }

                print("Success")
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
