//
//  AuthenticationView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/18/24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            NavigationLink {
              SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Create Account with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
//            NavigationLink {
//              SignInGoogleView()
//            } label: {
//                Text("Sign In with Google")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(height: 55)
//                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
            
            Spacer()
        }
        .navigationTitle("Sign In")
        .padding()
    }
}

//#Preview {
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
