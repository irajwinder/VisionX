//
//  VideoManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/6/23.
//

import Foundation
import AVKit

class VideoManager: NSObject {
    static let sharedInstance: VideoManager = {
        let instance = VideoManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    func playVideo(videoURL: URL, viewController: UIViewController) {
        if AVURLAsset(url: videoURL).isPlayable {
            // Create an AVPlayer with the video URL
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            // Present the AVPlayerViewController and start playing the video
            viewController.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }
}

let videoManagerInstance = VideoManager.sharedInstance
