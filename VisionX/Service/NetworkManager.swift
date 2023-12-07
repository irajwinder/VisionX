//
//  NetworkManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/22/23.
//

import UIKit

class NetworkManager : NSObject {
    
    static let sharedInstance : NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    //    // NSCache to store UIImage objects with NSString keys
    //    var cache = NSCache<NSString, UIImage>()
    //    let maxItemCount = 50
    //    
    //    
    //    // Retrieve an image from the cache using a key
    //    func getImage(forKey key: String) -> UIImage? {
    //        return cache.object(forKey: key as NSString)
    //    }
    //    
    //    // Store an image in the cache using a key
    //    func setImage(_ image: UIImage, forKey key: String) {
    //        cache.setObject(image, forKey: key as NSString)
    //    }
    
    func searchPhotos(query: String, perPage: Int, page: Int, completion: @escaping (PhotoResponse?) -> Void) {
        let apiUrl = "\(baseImageURL)/search?query=\(query)&per_page=\(perPage)&page=\(page)"
        
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
            let photoResponse = apiManagerInstance.decodePhotoResponse(data: data)
            completion(photoResponse)
        }
        task.resume()
    }
    
    func searchVideos(query: String, perPage: Int, page: Int, completion: @escaping (VideoResponse?) -> Void) {
        let apiUrl = "\(baseVideoURL)/search?query=\(query)&per_page=\(perPage)&page=\(page)"
        
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
            let videoResponse = apiManagerInstance.decodeVideoResponse(data: data)
            completion(videoResponse)
        }
        task.resume()
    }
    
    //download images from a given URL
    func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        // Create a data task to download the image from the given URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            // Pass data to the completion block
            completion(data)
        }
        // Resume the data task to start the download
        task.resume()
    }
}

let networkManagerInstance = NetworkManager.sharedInstance
