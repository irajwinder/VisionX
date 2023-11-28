//
//  NetworkManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/22/23.
//

import Foundation
import UIKit

class NetworkManager : NSObject {
    
    static let sharedInstance : NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    func searchPhotos(query: String, perPage: Int, completion: @escaping (PhotoResponse?) -> Void) {
        let apiUrl = "\(baseImageURL)/search?query=\(query)&per_page=\(perPage)"
        
        // 1. Get the url
        guard let requestURL = URL(string: apiUrl) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // 2. Get the URLRequest
        var urlRequest = URLRequest(url: requestURL)
        // Sets cache policy and timeout interval for the request
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
            apiManagerInstance.decodePhotoResponse(data: data, completion: completion)
        }
        task.resume()
    }
    
    //download images from a given URL
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Create a data task to download the image from the given URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            //Create a UIImage from the downloaded data
            let image = UIImage(data: data)
            completion(image)
        }
        // Resume the data task to start the download
        task.resume()
    }

}

let networkManagerInstance = NetworkManager.sharedInstance
