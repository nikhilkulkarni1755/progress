//
//  SignInEmailView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/20/24.
//

import SwiftUI

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
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
                
            } label: {
                Text("Sign In")
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
        .navigationTitle("Sign in with Email")
        
        
        
    }
}

#Preview {
    NavigationStack {
        SignInEmailView()
    }
}
