//
//  SearchView.swift
//  Melli_v2
//
//  Created by Rishikesh Balaji on 1/15/24.
//

import Foundation
import SwiftUI

// Configuration struct to store API-related configurations

struct Item: Identifiable, Decodable {
    let id: Int
    let adult: Bool
    let name: String
    let overview: String

}

struct SearchResult: Decodable {
    let results: [Item]

    enum CodingKeys: String, CodingKey {
        case results = "Results"
    }
}

struct ItemCardView: View {
    let item: Item
    let userId: String
    let contentType: String

    var body: some View {
        NavigationLink(destination: AddReviewView(item: item, userId: userId, contentType: contentType)) {
            
            VStack(alignment: .leading, spacing: 8) {
                // Placeholder content
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(item.overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }

}


struct SearchResultsView: View {
    let searchResult: SearchResult
    let userId: String
    let contentType: String

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(searchResult.results, id: \.id) { item in
                    ItemCardView(item: item, userId: userId, contentType: contentType)
                }
            }
            .padding()
        }
    }
}

func searchContent(contentType: String, searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
    // Construct the full URL using the baseURL and endpoint
    var fullURL = ""
    if (contentType == "show"){
        fullURL = APIConfig.baseURL + APIConfig.showSearchEndpoint
    }
    else if(contentType == "movie"){
        fullURL = APIConfig.baseURL + APIConfig.movieSearchEndpoint
    }
    let parameters: [String: Any] = [
        "search_term": searchTerm
    ]
    do {
        // Convert parameters to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)

        // Create URLRequest
        if let url = URL(string: fullURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST" // Adjust the HTTP method if needed
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Make the request using URLSession
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    completion(data, nil)
                }
            }
            task.resume()
        } else {
            // Handle invalid URL
            let invalidURLError = NSError(domain: "YourAppDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, invalidURLError)
        }
    } catch {
        // Handle JSON serialization error
        completion(nil, error)
    }
    
}


struct SearchView: View {
    // Replace YourSearchResultModel with your actual model properties
    
    
    
    
   
    
    
    @State private var searchTerm = ""
    @State private var searchResults: SearchResult = SearchResult(results: [])
    @State private var isSearching = false
    @State private var selectedTypeIndex = 0
    @State private var contentTypes = ["Movie", "Show"]
    
    let userId: String

    
    struct SearchBar: View {
        @Binding var searchTerm: String
        var onSearch: () -> Void

        var body: some View {
            HStack {
                TextField("Search", text: $searchTerm, onCommit: {
                    onSearch()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    onSearch()
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }

    var body: some View {
            VStack {
                HStack {
                    Picker("Select Type", selection: $selectedTypeIndex) {
                        ForEach(0..<contentTypes.count) {
                            Text(self.contentTypes[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                }
                SearchBar(searchTerm: $searchTerm, onSearch: {
                    // Trigger backend call
                    search()
                })
                .padding()
                Spacer()
                    
                if isSearching {
                   ProgressView("Searching...")
                       .padding()
               } else {
                   // Display search results
                   if !searchTerm.isEmpty {
                       if searchResults.results.isEmpty {
                           Text("No results found")
                               .padding()
                       } else {
                           SearchResultsView(searchResult: searchResults, userId: userId, contentType: contentTypes[selectedTypeIndex].lowercased())
                               .padding()
                       }
                   }
               }
            }
            .navigationTitle("Search")
            
    }

    private func search() {
        // Perform your backend call with the searchTerm
        // Set isSearching to true during the request and update searchResults when the request is complete
        isSearching = true

        var endPoint: String
        if (contentTypes[selectedTypeIndex].lowercased() == "show"){
            endPoint = APIConfig.showSearchEndpoint
        }
        else {
            endPoint = APIConfig.movieSearchEndpoint
        }
        let parameters: [String: Any] = [
            "search_term": searchTerm
        ]
        makeAPICall(method: "POST", endpoint: endPoint, parameters: parameters, completion: { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                // Process the received data
                do {
                    searchResults = try JSONDecoder().decode(SearchResult.self, from: data)
                    isSearching = false
                }
                catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        }
                    )
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(userId: "000179.d07894c3d292462dafb0919081384370.2132")
    }
}
