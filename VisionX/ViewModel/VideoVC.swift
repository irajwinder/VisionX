//
//  VideoVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class VideoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Videos"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "VideoVC" {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .search, target: self, action: #selector(seatchVideos))
            }
        }
    }
    
    @objc func seatchVideos() {
        
    }
}
