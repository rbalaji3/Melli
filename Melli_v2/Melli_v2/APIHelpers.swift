//
//  APIHelpers.swift
//  Melli_v2
//
//  Created by Rishikesh Balaji on 1/21/24.
//

import Foundation

struct APIConfig {
    static let baseURL = "http://127.0.0.1:5000"
    static let showSearchEndpoint = "/search_show"
    static let movieSearchEndpoint = "/search_movie"
    static let postReviewEndpoint = "/post_review"
    
}

struct PostReviewResponse: Decodable {
    let Success: String
}

func makeAPICall(method: String, endpoint: String, parameters: [String: Any], completion: @escaping (Data?, Error?) -> Void) {

    do {
        // Convert parameters to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)

        // Create URLRequest
        if let url = URL(string: APIConfig.baseURL + endpoint) {
            var request = URLRequest(url: url)
            request.httpMethod = method
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
