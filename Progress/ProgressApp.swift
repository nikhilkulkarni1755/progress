//
//  ProgressApp.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 4/2/24.
//

import SwiftUI
import Firebase

@main
struct ProgressApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var paymentManager = PaymentManager.shared
    
    init() {
        FirebaseApp.configure()
        print("firebase configured!")
    }

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(paymentManager)
//            NavigationStack {
//                AuthenticationView()
//            }
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
