//
//  ProgressApp.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 4/2/24.
//

import SwiftUI

@main
struct ProgressApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
