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
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group {
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
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
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
