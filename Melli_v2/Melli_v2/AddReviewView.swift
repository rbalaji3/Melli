//
//  AddReviewView.swift
//  Melli_v2
//
//  Created by Rishikesh Balaji on 1/15/24.
//

import Foundation

import SwiftUI

struct AddReviewView: View {
    let item: Item
    let userId: String
    let contentType: String
    @State private var rating: Double = 0.0
    @State private var notes: String = ""
    @State private var isSubmitting = false
    @State private var submitSuccess = false
    @State private var submitFailure = false
    @State private var showAlert = false

    


    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Display item details
            Text("Item Name: \(item.name)")
                .font(.title)
            // User ID
            Text("User ID: \(userId)")
                .foregroundColor(.gray)
            
            // User ID
            Text("Content Type: \(contentType)")
                .foregroundColor(.gray)
            
            // Rating scale
            VStack(alignment: .leading, spacing: 10) {
                Text("Rating:")
                Slider(value: $rating, in: 0...5, step: 1)
                    .accentColor(.blue)
            }
            
            // Notes
            VStack(alignment: .leading, spacing: 10) {
                Text("Notes:")
                TextField("Enter notes...", text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Submit Button
            Button(action: {
                submitReview { success, error in
                    if let error = error {
                        // Handle error
                        submitFailure = true

                    } else if success {
                        // Handle successful response
                        submitSuccess = true
                        print("Submit review successful.")
                    }
                    showAlert = true

                }
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(isSubmitting) // Disable the button while submitting
            
            // Any other details or controls you want to include
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Add Review", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(submitSuccess ? "Success" : "Failure"),
                message: Text(submitSuccess ? "Review submitted successfully" : "Review could not be submitted"),
                dismissButton: .default(Text("OK")) {
                    // Navigate back to the search view
                    // You can use navigationLink or other navigation methods here
                }
            )
        }
    }

    
    private func submitReview(completion: @escaping (Bool, Error?) -> Void) {
        // Perform your backend API call here
        // Set isSubmitting to true during the request
        isSubmitting = true

        let currentDate = Date()
        let parameters: [String: Any] = [
            "media_type": contentType.uppercased(),
            "user_id": userId,
            "item_id": String(item.id),
            "stars": rating,
            "timestamp": Int(currentDate.timeIntervalSince1970),
            "notes": notes
        ]

        makeAPICall(method: "POST", endpoint: APIConfig.postReviewEndpoint, parameters: parameters) { data, error in
            if let error = error {
                completion(false, error)
            } else if let _ = data {
                // Assuming a successful response if there's no error
                completion(true, nil)
            }
            isSubmitting = false
        }
    }
}
