//
//  SignUpView.swift
//  StudyChatApp
//
//  Created by Ekam Singh Chahal on 12/6/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appState: AppState
    
    private var isFormValid: Bool {
        // **LATER** - Add regular expression to check if email is in the correct format.
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && !displayName.isEmptyOrWhiteSpace
    }
    
    private func signUp() async{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await model.updateDisplayName(for: result.user, displayName: displayName)
            appState.routes.append(.login)
        } catch {
            // Handle error while logging in.
            appState.errorWrapper = ErrorWrapper(error: error)
        }
    }
   
    
    var body: some View {
        // Creating a form to take email, password and name as input for sign up.
        Form {
            TextField("Email", text: $email).textInputAutocapitalization(.never)
            SecureField("Password", text: $password).textInputAutocapitalization(.never)
            TextField("Display name", text: $displayName)
            
            //Sign Up button -> Includes validation
            HStack{
                Spacer()
                Button("SignUp") {
                    Task{
                        // Perform sign up when button is clicked.
                        await signUp()
                    }
                    
                }.disabled(!isFormValid).buttonStyle(.borderless)
                
                // Login button
                Button("Login") {
                    appState.routes.append(.login)
                    // Take the user to login screen
                }.buttonStyle(.borderless)
                Spacer()
            }
            
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(Model())
        .environmentObject(AppState())
}
