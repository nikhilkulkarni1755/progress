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
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func getAllActivities() async throws {
        guard let user else { return }
        let result: [Activity] = try await UserManager.shared.getAllActivities(userId: user.userId)
        self.mainActivity = result[0]
        self.premiumActivities = [
            result[1],
            result[2]
        ]
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
        
        if id == "activity_1" {
            guard let mainActivity else { return }
            let currentProgress = mainActivity.progress ?? 0
            let updatedActivity = Activity(dateLastUpdated: mainActivity.dateLastUpdated, name: mainActivity.name, progress: currentProgress + 1)
            Task {
                try await UserManager.shared.updateProgress(user: user.userId, activity: updatedActivity, id: id)
                try await getAllActivities()
//                self.user = try await UserManager.shared.getUser(userId: user.userId)
            }
        }
        else if id == "activity_2" {
            guard let premiumActivities else { return }
            let currentProgress = premiumActivities[0].progress ?? 0
            let updatedActivity = Activity(dateLastUpdated: premiumActivities[0].dateLastUpdated, name: premiumActivities[0].name, progress: currentProgress + 1)
            Task {
                try await UserManager.shared.updateProgress(user: user.userId, activity: updatedActivity, id: id)
                try await getAllActivities()
//                self.premiumActivities = try await UserManager.shared.get(userId: user.userId)
//                self.user = try await UserManager.shared.getUser(userId: user.userId)
            }
        }
        else {
            // activity_3
            guard let premiumActivities else { return }
            let currentProgress = premiumActivities[1].progress ?? 0
            let updatedActivity = Activity(dateLastUpdated: premiumActivities[1].dateLastUpdated, name: premiumActivities[1].name, progress: currentProgress + 1)
            Task {
                try await UserManager.shared.updateProgress(user: user.userId, activity: updatedActivity, id: id)
                try await getAllActivities()
//                self.mainActivity = try await UserManager.shared.getMainActivity(userId: user.userId)
//                self.user = try await UserManager.shared.getUser(userId: user.userId)
            }
        }
        
//        let currentProgress = user.progress ?? 0
//        let updatedUser = DBUser(userId: user.userId, isPremium: user.isPremium, email: user.email, progress: currentProgress + 1, dateCreated: user.dateCreated)
//        Task {
//            try await UserManager.shared.updateProgress(user: updatedUser)
        
//        }
    }
    
//    func getActivities() async throws {
//        guard let user else { return }
//        Task {
////            try await UserManager.shared.addMainActivity(userId:user.userId, name: "quidditch")
//            self.mainActivity = try await UserManager.shared.getMainActivity(userId: user.userId)
//        }
////        try await UserManager.shared.getUser(userId: user.userId)
//    }
    
//    func getPremiumActivities() async throws {
//        guard let user else { return }
//        Task {
////            try await UserManager.shared.addMainActivity(userId:user.userId, name: "quidditch")
//            self.premiumActivities = [
//                try await UserManager.shared.getSecondActivity(userId: user.userId),
//                try await UserManager.shared.getThirdActivity(userId: user.userId),
//            ]
//        }
//    }
    
    
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
                    
                    Text("Did you complete \(mainActivity) today?")
                    Button {
                        Task {
                            try await viewModel.toggleProgress(id:"activity_1")
                        }
                    } label: {
                        Text("Complete ✅")
                    }
                    
                    // TextField("", text: name)
                }
            }
            if let activities = viewModel.premiumActivities, !activities.isEmpty, let act2 = activities[0].name, let progress2 = activities[0].progress, let progress3 = activities[1].progress, let act3 = activities[1].name {
                if let isPremium = viewModel.user?.isPremium {
                    if isPremium == true {
                        Section(header: Text("\(act2)")) {
                            Text("Progress: \(progress2)")
                            Text("Did you complete \(act2) today?")
                            Button {
                                Task {
                                    try await viewModel.toggleProgress(id:"activity_2")
                                }
                            } label: {
                                Text("Complete ✅")
                            }
                        }
                        Section(header: Text("\(act3)")) {
                            Text("Progress: \(progress3)")
                            Text("Did you complete \(act3) today?")
                            Button {
                                Task {
                                    try await viewModel.toggleProgress(id:"activity_3")
                                }
                            } label: {
                                Text("Complete ✅")
                            }
                        }
                    }
                    else {
                        Button {
                            
                        } label: {
                            Text("Get Premium")
                        }
                    }
                }
            }
            
        }.task {
            
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getAllActivities()
//            try? await viewModel.getActivities()
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
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
