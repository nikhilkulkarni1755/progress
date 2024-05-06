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

//enum Emoji:String, CaseIterable {
//    case 😁, 🧐, 😈, 💩, 🫤
//}

//struct Location: Codable, Hashable {
//    let location: String
//}

struct Activity: Codable, Hashable {
    let name: String
    let id: Int
//    let isStreak: Bool
    let streakCount: Int
}

struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 70)
        }
        else {
            Image("")
                .frame(width: 130, height: 70)
                .background(Color.gray)
                .aspectRatio(contentMode: .fill)
                .onAppear {
                    getData()
                }
        }
    }
    
    private func getData() {
        guard let url = URL(string:urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if err == nil {
                self.data = data
//            }
        }
        task.resume()
    }
}

struct ContentView: View {
    
//    @State var selection: Emoji = .😁
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
//        Text("Trying to get HTTP Calls to work")
        NavigationView {
            List {
                ForEach(viewModel.courses, id: \.self) {
                    course in HStack {
                        
                        URLImage(urlString: course.image)
                            .frame(width: 130, height: 70)
//                            .background(Color.gray)
                            
                        Text(course.name).bold()
                    }.padding(3)
                }
            }.navigationTitle("Courses")
                .onAppear {
                    viewModel.sendAPIRequest()
                }
//            Text("API Response: \(viewModel.apiResponse ?? "No response yet")")
//                        .onAppear {
//                            viewModel.sendAPIRequest()
                        }
//            VStack {
//                Text(selection.rawValue)
//                    .font(.system(size:150))
                
//                Picker("Select Emoji", selection: $selection) {
//                    ForEach(Emoji.allCases, id: \.self) {
//                        emoji in Text(emoji.rawValue)
//                    }
//                }.pickerStyle(.segmented)
                
                
            }
//        .padding().navigationTitle("Weather App")
//                .navigationSubtitle("test done!")
    }

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
