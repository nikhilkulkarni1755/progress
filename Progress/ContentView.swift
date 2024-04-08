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

struct Course: Codable, Hashable {
    let name: String
    let image: String
}

struct ContentView: View {
    
//    @State var selection: Emoji = .😁
    @State var viewModel = ViewModel()
    
    var body: some View {
        
        NavigationView {
            List {
                Text("Trying to get HTTP Calls to work")
                ForEach(viewModel.courses, id: \.self) {
                    course in HStack {
                        Image("")
                            .frame(width: 130, height: 70)
                            .background(Color.gray)
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

class ViewModel: ObservableObject {
//    @Published var apiResponse: String?
    @Published var courses: [Course] = []
    
    func sendAPIRequest() {
        guard let url = URL(string:"https://iosacademy.io/api/v1/courses/index.php") else { return }
//        guard let url = URL(string: "https://nsk1755server.com/ip") else { return }
//            let session = URLSession(configuration: .default)
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self?.courses = courses
                }
                print("Done!")
                print(courses)
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
