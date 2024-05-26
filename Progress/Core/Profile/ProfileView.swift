//
//  ProfileView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/24/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentPremium = user.isPremium ?? false
        let updatedUser = DBUser(userId: user.userId, isPremium: !currentPremium, email: user.email, progress: user.progress, dateCreated: user.dateCreated)
        Task {
            try await UserManager.shared.updateUserPremiumStatus(user: updatedUser)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            if let userId = viewModel.user?.userId {
                Text("User Id: \(userId)")

                if let email = viewModel.user?.email {
                    Text("Email: \(email)")
                }
                if let progress = viewModel.user?.progress {
                    Text("Progress: \(progress)")
                }
                if let dateCreated = viewModel.user?.dateCreated {
                    Text("Date Created: \(String(describing: dateCreated))")
                }
                if let isPremium = viewModel.user?.isPremium {
                    Text("Is Premium: \(String(describing: isPremium))")
                }
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("Change Premium Status")
                }
            }
            
            
        }.task {
            try? await viewModel.loadCurrentUser()
//            print("done loading current user")
//            print(String(describing: viewModel.user?.userId))
        }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
