//
//  EditActivitiesView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/31/24.
//

import SwiftUI

final class EditActivitiesViewModel: ObservableObject {
    @Published var activityName = ""
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
            
            Button {
                Task {
                    
                }
            } label: {
                Text("Reset Activity 1")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.blue)
                .cornerRadius(10)
            }
            
            Button {
                Task {
                    
                }
            } label: {
                Text("Reset Activity 2")
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
                    
                }
            } label: {
                Text("Reset Activity 3")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.blue)
                .cornerRadius(10)
            }
            
            Spacer()
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
