//
//  NetworkManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/22/23.
//

import Foundation

class NetworkManager : NSObject {
    
    static let sharedInstance : NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
}

let networkManagerInstance = NetworkManager.sharedInstance
