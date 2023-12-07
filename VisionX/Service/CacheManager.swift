//
//  CacheManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/6/23.
//

import Foundation

class CacheManager: NSObject {
    static let sharedInstance: CacheManager = {
        let instance = CacheManager()
        return instance
    }()
    
    private override init() {
        super.init()
        cache.countLimit = maxItemCount //50 images
    }
    
    // NSCache to store NSData objects with NSString keys
    var cache = NSCache<NSString, NSData>()
    let maxItemCount = 50
    
    // Retrieve an image data from the cache using a key
    func getImageData(forKey key: String) -> Data? {
        if let cachedData = cache.object(forKey: key as NSString) as Data? {
            return cachedData
        }
        return nil
    }
    
    // Store an image in the cache using a key
    func setImageData(_ imageData: Data, forKey key: String) {
        cache.setObject(imageData as NSData, forKey: key as NSString)
    }
    
    func clearImageCache() {
        cache.removeAllObjects()
    }
}

let cacheManagerInstance = CacheManager.sharedInstance
