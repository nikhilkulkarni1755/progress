//
//  ContentView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 4/2/24.
//

import SwiftUI

enum Emoji:String, CaseIterable {
    case 😁, 🧐, 😈, 💩, 🫤
}

struct ContentView: View {
    
    @State var selection: Emoji = .😁
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text(selection.rawValue)
                    .font(.system(size:150))
                
                Picker("Select Emoji", selection: $selection) {
                    ForEach(Emoji.allCases, id: \.self) {
                        emoji in Text(emoji.rawValue)
                    }
                }.pickerStyle(.segmented)
                
                
            }.padding().navigationTitle("Emoji Lovers")
        }
    }
}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
