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
    
    // Decode Photo response
    func decodePhotoResponse(data: Data, completion: @escaping (PhotoResponse?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let photoSearchResponse = try decoder.decode(PhotoResponse.self, from: data)
            completion(photoSearchResponse)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    // Decode Video response
    func decodeVideoResponse(data: Data, completion: @escaping (VideoResponse?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let videoSearchResponse = try decoder.decode(VideoResponse.self, from: data)
            completion(videoSearchResponse)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            completion(nil)
        }
    }
}

let apiManagerInstance = APIManager.sharedInstance


