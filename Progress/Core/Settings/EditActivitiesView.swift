//
//  EditActivitiesView.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/31/24.
//

import SwiftUI

struct EditActivitiesView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
//    EditActivitiesView()
    NavigationStack {
        EditActivitiesView(showSignInView: .constant(false))
    }
}
