//
//  AddReviewView.swift
//  Melli_v2
//
//  Created by Rishikesh Balaji on 1/15/24.
//

import Foundation
import SwiftUI


import SwiftUI

import Foundation
struct YourDataModel: Codable {
    var user_id: String
    var item_id: String
    var media_type: String
    var stars: Int
//    var timestamp: Int
    var notes: String
    
    // Add other properties as needed
}


struct DataEntryView: View {
    
    
    let user_id: String
    // Updated initializer
    init(user_id: String) {
        self.user_id = user_id
    }
//    @State private var user_id = ""
    @State private var item_id = ""
    @State private var media_type = ""
    @State private var stars = 1
//    @State private var timestamp = ""
    @State private var notes = ""

    var body: some View {
        VStack {
            TextField("Item ID", text: $item_id)
                .padding()

            TextField("Media Type", text: $media_type)
                .padding()

            Stepper(value: $stars, in: 1...5) {
                Text("Stars: \(stars)")
            }
            .padding()

            TextEditor(text: $notes)
                .frame(height: 100)
                .padding()

            Button("Send Data") {
                sendDataToBackend()
            }
            .padding()
        }
        .padding()
    }

    func sendDataToBackend() {

        let dataModel = YourDataModel(
            user_id: self.user_id,
            item_id: item_id,
            media_type: media_type,
            stars: stars,
            notes: notes
        )
        print(dataModel)
        // Rest of the code remains the same...
    }
}

struct DataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DataEntryView(user_id: "000179.d07894c3d292462dafb0919081384370.2132")
    }
}

