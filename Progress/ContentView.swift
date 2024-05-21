//
//  ContentView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 4/2/24.
//

// https://nsk1755server.com/ip
// responseType: text
// https://iosacademy.io/api/v1/courses/index.php

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello New App")
                .font(.system(size:36))
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
