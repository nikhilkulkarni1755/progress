//
//  SignInEmailView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/20/24.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
//        @StateObject private var viewModel = SignInEmailViewModel()
        VStack {
            TextField("Email...", text:$viewModel.email)
                .cornerRadius(10)
                .padding()
                .background(Color.gray.opacity(0.4))
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    }
                    catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    }
                    catch {
                        print(error)
                    }
                }
                
            } label: {
                Text("Create Account and Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Create and Sign In")
   
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
