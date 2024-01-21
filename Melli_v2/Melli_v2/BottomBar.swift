//
//  BottomBar.swift
//  Melli_v2
//
//  Created by Rishikesh Balaji on 1/21/24.
//

import SwiftUI

enum Tabs: Int {
    case feed = 0
    case addReview = 1
    case profile = 2
}


struct BottomBarv1: View {
    let userId: String
    
    var body: some View {
        TabView {
            FeedView(userId: userId)
                .tabItem {
                    Label("Feed", systemImage: "list.bullet.rectangle")
                }
            SearchView(userId: userId)
                .tabItem {
                    Label("Add Review", systemImage: "plus")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
        }
        
    }
}

#Preview {
    BottomBarv1(userId: "000179.d07894c3d292462dafb0919081384370.2132")
}
