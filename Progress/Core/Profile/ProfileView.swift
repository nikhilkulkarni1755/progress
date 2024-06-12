//
//  ProfileView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/24/24.
//

import SwiftUI
import StoreKit

@MainActor
final class ProfileViewModel: ObservableObject {
//    @Published var name: String = ""
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var mainActivity: Activity? = nil
    @Published private(set) var premiumActivities: [Activity]? = []
    // older payment code
//    @Published private(set) var products: [Product] = []
    
//    @StateObject var storeKit = PurchaseManager()
    @EnvironmentObject private var paymentManager: PaymentManager
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func getProducts() async throws {
//        self.products = try await PurchaseManager.shared.getProducts()
        
        guard let user else { return }
        
        if let isPrem = user.isPremium {
            if !isPrem {
                //hopefully this gets us our first and ONLY product currently in the store.
                let product = paymentManager.allProducts.first
                
                print("\(String(describing: product?.title))")
//                try await PaymentManager.purchaseProduct()
            }
        }
    }
    
    func getAllActivities() async throws {
        guard let user else { return }
        
        self.mainActivity = try await UserManager.shared.getMainActivity(userId: user.userId)
        self.premiumActivities = [
            try await UserManager.shared.getSecondActivity(userId: user.userId),
            try await UserManager.shared.getThirdActivity(userId: user.userId)
        ]
//        let result: [Activity] = try await UserManager.shared.getAllActivities(userId: user.userId)
//        self.mainActivity = result[0]
//        self.premiumActivities = [
//            result[1],
//            result[2]
//        ]
//        if (self.premiumActivities? == nil) {
//            print("empty premium")
//        }
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
    
    func purchasePremium() async throws {
        guard let user else { return }
//        guard let self.products else { return }
        let updatedUser = DBUser(userId: user.userId, isPremium: true, email: user.email, dateCreated: user.dateCreated)
//        guard let products else { return }
//        if let product = self.products.first {
//            Task {
    //            if let product = self.products?.first {
    //                let _ = try await PurchaseManager.shared.purchase(user: updatedUser, product:product)
    ////                try await getAllActivities()
    //                try await loadCurrentUser()
    //            }t
                
    //                self.user = try await UserManager.shared.getUser(userId: user.userId)
                
                
//                do {
//                    let transaction = try await PurchaseManager.shared.purchase(user: updatedUser, product: product)
//                    if let transaction = transaction {
//                        print("Purchase successful")
//                    }
//                    else {
//                        print("not completed")
//                    } 
//                } catch {
//                    print("purchase failed w error \(error)")
//                }
//            }
//        }
//        else {
//            print("products.first aint there")
//        }
//        
    }
    
    func toggleProgress(id: String, reset: Bool) async throws {
        guard let user else { return }
        
        if id == "activity_1" {
            
            guard let mainActivity else { return }
            var currentProgress = mainActivity.progress ?? 0
            currentProgress += 1
            if reset {
                currentProgress = 1
            }
            
            let updatedActivity = Activity(dateLastUpdated: Date(), name: mainActivity.name, progress: currentProgress)
            Task {
                try await UserManager.shared.updateProgress(user: user.userId, activity: updatedActivity, id: id)
                try await getAllActivities()
//                self.user = try await UserManager.shared.getUser(userId: user.userId)
            }
        }
        else if id == "activity_2" {
            guard let premiumActivities else { return }
//            let currentProgress = premiumActivities[0].progress ?? 0
            var currentProgress = premiumActivities[0].progress ?? 0
            currentProgress += 1
            if reset {
                currentProgress = 1
            }
            let updatedActivity = Activity(dateLastUpdated: Date(), name: premiumActivities[0].name, progress: currentProgress)
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
//            let currentProgress = premiumActivities[1].progress ?? 0
            var currentProgress = premiumActivities[1].progress ?? 0
            currentProgress += 1
            if reset {
                currentProgress = 1
            }
            let updatedActivity = Activity(dateLastUpdated: Date(), name: premiumActivities[1].name, progress: currentProgress)
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
    @EnvironmentObject var paymentManager: PaymentManager
    
    // adding
    
//    From the tutorial
//    @StateObject var storeKit = PurchaseManager()
    
    var body: some View {
        List {
            if let mainActivity = viewModel.mainActivity?.name {
                
//                if let prod = viewModel.products {
//                    Text("\(String(describing: (prod)))")
//                }
//                
                
                
                Section(header: Text("**\(mainActivity)**")) {
                    if let progress = viewModel.mainActivity?.progress {
                        Text("Progress: \(progress)")
                    }
                    
                    if let dateAccessed = viewModel.mainActivity?.dateLastUpdated {
                        let cal = Calendar.current
                        let currDate = cal.dateComponents([.year, .month, .day], from: Date())
                        let actDate = cal.dateComponents([.year, .month, .day], from: dateAccessed)
                        if let lastAccessedDate = cal.date(from: actDate) {
                            if let currentDate = cal.date(from: currDate) {
                                if let dayDifference = cal.dateComponents([.day], from: lastAccessedDate, to: currentDate).day {
//                                    let res = dayDifference == -1 || dayDifference == 1
//                                    Text("\(String(describing: dayDifference))")
//                                    Text("day Difference: \(String(describing: res))")
                                    
                                    if dayDifference == 1 {
                                        Text("Did you complete \(mainActivity) today?")
                                        Button {
                                            Task {
                                                try await viewModel.toggleProgress(id:"activity_1", reset: false)
                                            }
                                        } label: {
                                            Text("Complete ✅")
                                        }
                                    }
                                    else if dayDifference > 1 {
                                        Text("Did you complete \(mainActivity) today?")
                                        Button {
                                            Task {
                                                try await viewModel.toggleProgress(id:"activity_1", reset: true)
                                            }
                                        } label: {
                                            // , but we are resetting since not in a row
                                            Text("Complete ✅")
                                        }
                                    }
                                    else {
                                        Text("Check in tomorrow for \(mainActivity)")
                                    }
                                }
                            }
                        }
                    }
                    else {
                        Text("No Date found")
                    }
                }
            }
            if let activities = viewModel.premiumActivities, !activities.isEmpty, let act2 = activities[0].name, let progress2 = activities[0].progress, let progress3 = activities[1].progress, let act3 = activities[1].name, let date2 = activities[0].dateLastUpdated, let date3 = activities[1].dateLastUpdated  {
                if let isPremium = viewModel.user?.isPremium {
                    if isPremium == true {
                        Section(header: Text("\(act2)")) {
                            Text("Progress: \(progress2)")
                            let cal = Calendar.current
                            let currDate = cal.dateComponents([.year, .month, .day], from: Date())
                            let actDate = cal.dateComponents([.year, .month, .day], from: date2)
                            if let lastAccessedDate = cal.date(from: actDate) {
                                if let currentDate = cal.date(from: currDate) {
                                    if let dayDifference = cal.dateComponents([.day], from: lastAccessedDate, to: currentDate).day {
//                                        let res = dayDifference == -1 || dayDifference == 1
//                                        Text("\(String(describing: dayDifference))")
//                                        Text("day Difference: \(String(describing: res))")
                                        if dayDifference == 1 {
                                            Text("Did you complete \(act2) today?")
                                            Button {
                                                Task {
                                                    try await viewModel.toggleProgress(id:"activity_2", reset: false)
                                                }
                                            } label: {
                                                Text("Complete ✅")
                                            }
                                        }
                                        else if dayDifference > 1 {
                                            Text("Did you complete \(act2) today?")
                                            Button {
                                                Task {
                                                    try await viewModel.toggleProgress(id:"activity_2", reset: true)
                                                }
                                            } label: {
                                                // , but we are resetting since not in a row
                                                Text("Complete ✅")
                                            }
                                        }
                                        else {
                                            Text("Check in tomorrow for \(act2)")
                                        }
                                    }
                                }
                            }
                        }
                        Section(header: Text("\(act3)")) {
                            Text("Progress: \(progress3)")
                            let cal = Calendar.current
                            let currDate = cal.dateComponents([.year, .month, .day], from: Date())
                            let actDate = cal.dateComponents([.year, .month, .day], from: date3)
                            if let lastAccessedDate = cal.date(from: actDate) {
                                if let currentDate = cal.date(from: currDate) {
                                    if let dayDifference = cal.dateComponents([.day], from: lastAccessedDate, to: currentDate).day {
                                        // this should be 1, not -1
//                                        let res = dayDifference == -1 || dayDifference == 1
//                                        Text("\(String(describing: dayDifference))")
//                                        Text("day Difference: \(String(describing: res))")
                                        
                                        if dayDifference == 1 {
                                            Text("Did you complete \(act3) today?")
                                            Button {
                                                Task {
                                                    try await viewModel.toggleProgress(id:"activity_3", reset: false)
                                                }
                                            } label: {
                                                Text("Complete ✅")
                                            }
                                        }
                                        else if dayDifference > 1 {
                                            Text("Did you complete \(act3) today?")
                                            Button {
                                                Task {
                                                    try await viewModel.toggleProgress(id:"activity_3", reset: true)
                                                }
                                            } label: {
                                                // , but we are resetting since not in a row
                                                Text("Complete ✅")
                                            }
                                        }
                                        else {
                                            Text("Check in tomorrow for \(act3)")
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Section(header: Text("For More Activities")) {
                            Button {
                                Task {
                                    try await viewModel.purchasePremium()
//                                    try await storeKit.purchase(user: user, product: product)
                                }
                            } label: {
                                Text("Get Premium")
                            }
                        }
                        
                    }
                } 
//                else {
//                    Button {
//
//                    } label: {
//                        Text("Get Premium 2")
//                    }
//                }
            } 
//            else {
//                Button {
//
//                } label: {
//                    Text("Get Premium")
//                }
//            }
        }.task {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getAllActivities()
            try? await viewModel.getProducts()
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
