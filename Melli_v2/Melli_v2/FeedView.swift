//
//  FeedView.swift
//  Melli_v2
//
//  Created by Rishikesh Balaji on 1/21/24.
//

import SwiftUI

struct FeedView: View {
    
    let userId: String
    @State var selectedTab: Tabs = .feed
    
    
    var body: some View {
            VStack {
                Text("My feed is so empty :(")

            }
        
    }
}

#Preview {
    FeedView(userId: "000179.d07894c3d292462dafb0919081384370.2132")
}
