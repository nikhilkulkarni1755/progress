//
//  SettingsView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/23/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            
            Section(header: Text("Activities")) {
                NavigationLink {
                    EditActivitiesView(showSignInView: $showSignInView)
                } label: {
                    Text("Edit Your Activities")
                }
            }
            
            Section(header: Text("Your Account")) {
                Button("Log Out") {
                    Task {
                        do {
                            try viewModel.logOut()
                            showSignInView = true
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button("Reset Password") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("Password Reset!")
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            
            
            
//            Button("Edit Activities") {
            
        }.navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
