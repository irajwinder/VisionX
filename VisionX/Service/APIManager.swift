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
    func decodePhotoResponse(data: Data) -> PhotoResponse? {
        do {
            let decoder = JSONDecoder()
            let photoSearchResponse = try decoder.decode(PhotoResponse.self, from: data)
            return photoSearchResponse
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Decode Video response
    func decodeVideoResponse(data: Data) -> VideoResponse? {
        do {
            let decoder = JSONDecoder()
            let videoSearchResponse = try decoder.decode(VideoResponse.self, from: data)
            return videoSearchResponse
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

let apiManagerInstance = APIManager.sharedInstance


