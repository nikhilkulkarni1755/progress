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
    @Published private(set) var mainActivity: Activity? = nil
    @Published private(set) var premiumActivities: [Activity]? = []
    
//    @State var selectedFlavor: Flavor = .chocolate
    
//    enum Flavor: String, CaseIterable, Identifiable {
//        case chocolate, vanilla, strawberry
//        var id: Self { self }
//    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
//    func togglePremiumStatus() {
//        guard let user else { return }
//        let currentPremium = user.isPremium ?? false
//        let updatedUser = DBUser(userId: user.userId, isPremium: !currentPremium, email: user.email, dateCreated: user.dateCreated)
//        Task {
//            try await UserManager.shared.updateUserPremiumStatus(user: updatedUser)
//            self.user = try await UserManager.shared.getUser(userId: user.userId)
//        }
//    }
    
    func toggleProgress(id: String) async throws {
        guard let user else { return }
        guard let mainActivity else { return }
//        guard let premiumActivities else { return }
        
        if id == "activity_1" {
            let currentProgress = mainActivity.progress ?? 0
            let updatedActivity = Activity(dateLastUpdated: mainActivity.dateLastUpdated, name: mainActivity.name, progress: currentProgress + 1)
            Task {
                try await UserManager.shared.updateProgress(user: user.userId, activity: updatedActivity, id: id)
                self.mainActivity = try await UserManager.shared.getMainActivity(userId: user.userId)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            }
        }
        else if id == "activity_2" {
            
        }
        else {
            // activity_3
        }
        
//        let currentProgress = user.progress ?? 0
//        let updatedUser = DBUser(userId: user.userId, isPremium: user.isPremium, email: user.email, progress: currentProgress + 1, dateCreated: user.dateCreated)
//        Task {
//            try await UserManager.shared.updateProgress(user: updatedUser)
        
//        }
    }
    
    func getActivities() async throws {
        guard let user else { return }
        Task {
//            try await UserManager.shared.addMainActivity(userId:user.userId, name: "quidditch")
            self.mainActivity = try await UserManager.shared.getMainActivity(userId: user.userId)
        }
//        try await UserManager.shared.getUser(userId: user.userId)
    }
    
    func getPremiumActivities() async throws {
        guard let user else { return }
        Task {
//            try await UserManager.shared.addMainActivity(userId:user.userId, name: "quidditch")
            self.premiumActivities = try await UserManager.shared.getPremiumActivities(userId: user.userId)
        }
    }
    
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            if let mainActivity = viewModel.mainActivity?.name {
                Section(header: Text("**\(mainActivity)**")) {
                    if let progress = viewModel.mainActivity?.progress {
                        Text("Progress: \(progress)")
                    }
                    
                    Text("Did you complete the activity today?")
                    Button {
                        Task {
                            try await viewModel.toggleProgress(id: "activity_1")
                        }
                    } label: {
                        Text("Complete ✅")
                    }
                }
                if let isPremium = viewModel.user?.isPremium {
                    if isPremium {
    //                    ideally should have name of activity here
                        
                        
                    }
                    else {
                        Section(header: Text("For more Activities")) {
                            Button {
                                
                            } label: {
                                Text("Get Premium")
                            }
                        }
                    }
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
            
            
            
            
            
        }.task {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getActivities()
//            try? await viewModel.getPremiumActivities()

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
        
//        Picker("Activities", selection: $viewModel.selectedFlavor) {
//            Text("Chocolate").tag(ProfileViewModel.Flavor.chocolate)
//            Text("Vanilla").tag(ProfileViewModel.Flavor.vanilla)
//            Text("Strawberry").tag(ProfileViewModel.Flavor.strawberry)
//        }.pickerStyle(.segmented)
        
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
