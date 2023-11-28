//
//  APIManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/22/23.
//

import Foundation

class APIManager: NSObject {
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    func searchPhotos(query: String, perPage: Int, completion: @escaping (PhotoResponse?) -> Void) {
        let baseURL = "https://api.pexels.com/v1"
        let apiUrl = "\(baseURL)/search?query=\(query)&per_page=\(perPage)"
        
        // 1. Get the url
        guard let requestURL = URL(string: apiUrl) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // 2. Get the URLRequest
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.cachePolicy = .useProtocolCachePolicy
        urlRequest.timeoutInterval = 30.0
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        
        //3. Make API request
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            // Decode JSON response
            do {
                let decoder = JSONDecoder()
                let photoSearchResponse = try decoder.decode(PhotoResponse.self, from: data)
                completion(photoSearchResponse)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
    
}

let apiManagerInstance = APIManager.sharedInstance


