//
//  RootView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/23/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try?AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
}

#Preview {
    RootView()
}
