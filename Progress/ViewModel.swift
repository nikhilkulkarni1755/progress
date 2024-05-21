//
//  ViewModel.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 4/8/24.
//

import Foundation
import SwiftUI

//struct Course: Codable, Hashable {
//    let name: String
//    let image: String
//}

class ViewModel: ObservableObject {
//    @Published var apiResponse: String?
//    @Published var courses: [Course] = []
//    
//    func sendAPIRequest() {
//        guard let url = URL(string:"https://iosacademy.io/api/v1/courses/index.php") else { return }
////        guard let url = URL(string: "https://nsk1755server.com/ip") else { return }
////            let session = URLSession(configuration: .default)
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let data = data, error == nil else {
//                return
//            }
//            
//            do {
//                let courses = try JSONDecoder().decode([Course].self, from: data)
//                DispatchQueue.main.async {
//                    self?.courses = courses
//                }
//                print("Done!")
//                print(courses)
//            }
//            catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
}
