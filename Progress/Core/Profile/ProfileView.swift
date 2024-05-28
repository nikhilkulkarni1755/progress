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
    
//    @State var selectedFlavor: Flavor = .chocolate
    
//    enum Flavor: String, CaseIterable, Identifiable {
//        case chocolate, vanilla, strawberry
//        var id: Self { self }
//    }
    
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
    
    func toggleProgress() {
        guard let user else { return }
        let currentProgress = user.progress ?? 0
        let updatedUser = DBUser(userId: user.userId, isPremium: user.isPremium, email: user.email, progress: currentProgress + 1, dateCreated: user.dateCreated)
        Task {
            try await UserManager.shared.updateProgress(user: updatedUser)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func getActivities() {
        guard let user else { return }
        Task {
            try await UserManager.shared.addMainActivity(userId:user.userId, name: "quidditch")
//            self.user = try await UserManager.shared.getMainActivity(userId: user.userId)
        }
//        try await UserManager.shared.getUser(userId: user.userId)
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            if let progress = viewModel.user?.progress {
                Text("Progress: \(progress)")
            }
            
            Text("Did you complete the activity today?")
            Button {
                viewModel.toggleProgress()
            } label: {
                Text("✅✅✅")
            }
            
            if let is_premium = viewModel.user?.isPremium {
                if is_premium {
                    Text("We can add two more activities here!")
                }
            }
//            Button {
//                viewModel.togglePremiumStatus()
//            } label: {
//                Text("Change Premium Status")
//            }
//            if let userId = viewModel.user?.userId {
//                Text("User Id: \(userId)")
//
//                if let email = viewModel.user?.email {
//                    Text("Email: \(email)")
//                }
//                
//                if let dateCreated = viewModel.user?.dateCreated {
//                    Text("Date Created: \(String(describing: dateCreated))")
//                }
//                if let isPremium = viewModel.user?.isPremium {
//                    Text("Is Premium: \(String(describing: isPremium))")
//                }
                
//            }
//            Picker("Activities", selection: $viewModel.selectedFlavor) {
//                Text("Chocolate").tag(ProfileViewModel.Flavor.chocolate)
//                Text("Vanilla").tag(ProfileViewModel.Flavor.vanilla)
//                Text("Strawberry").tag(ProfileViewModel.Flavor.strawberry)
//            }
            
            
        }.task {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getActivities()
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
