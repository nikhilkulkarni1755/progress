//
//  EditActivitiesView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/31/24.
//

import SwiftUI

final class EditActivitiesViewModel: ObservableObject {
    @Published var activityName = ""
    @Published var activity = ""
    
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
//        if (self.premiumActivities? == nil) {
//            print("empty premium")
//        }
    }
    
    func editActivity() async throws {
        guard let user else { return }
        var act = ""
        if activity == "Activity 1" {
            act = "activity_1"
        }
        else if activity == "Activity 2" {
            act = "activity_2"
        }
        else {
            act = "activity_3"
        }
        
        try await UserManager.shared.editActivity(user: user, activity: act, name: activityName)
    }
}

struct EditActivitiesView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = EditActivitiesViewModel()

    var body: some View {
        
        VStack {
            
            Group {
                Text("You will lose progress if you reset your activity")
                    .padding()
                    .underline()
                    .font(.headline)
                
//                Text("").padding()
            }
//            List {
            
//            }
            
            
            TextField("Edit Activity Name", text: $viewModel.activityName)
                .cornerRadius(10)
                .padding()
                .background(Color.gray.opacity(0.4))
            
            if let act1 = viewModel.mainActivity?.name {
                Button {
                    Task {
                        viewModel.activity = "Activity 1"
                    }
                } label: {
                    Text("Reset \(act1)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            
            if let activities = viewModel.premiumActivities, !activities.isEmpty, let act2 = activities[0].name, let act3 = activities[1].name {
                if let isPremium = viewModel.user?.isPremium {
                    if isPremium == true {
                        Button {
                            Task {
                                viewModel.activity = "Activity 2"
                            }
                        } label: {
                            Text("Reset \(act2)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity
                            )
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                        Button {
                            Task {
                                viewModel.activity = "Activity 3"
                            }
                        } label: {
                            Text("Reset \(act3)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            
//            if let confirm = viewModel.activity {
//            if let confirm = viewModel.activity {
            if viewModel.activity == "Activity 1" {
                Button {
                    Task {
                        try await viewModel.editActivity()
                    }
                } label: {
                    Text("Confirm reset Activity 1")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            if let isPremium = viewModel.user?.isPremium {
                if isPremium == true {
                    if viewModel.activity == "Activity 2" {
                        Button {
                            Task {
                                try await viewModel.editActivity()
                            }
                        } label: {
                            Text("Confirm reset Activity 2")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    if viewModel.activity == "Activity 3" {
                        Button {
                            Task {
                                try await viewModel.editActivity()
                            }
                        } label: {
                            Text("Confirm reset Activity 3")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
            }
//            }
            
            Spacer()
            
            
        }
        .task {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getAllActivities()
        }
        .padding()
        .navigationTitle("Reset Your Activities")
        
        
    }
}

#Preview {
//    EditActivitiesView()
    NavigationStack {
        EditActivitiesView(showSignInView: .constant(false))
    }
}
