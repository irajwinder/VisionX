//
//  ImageVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class ImageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose Orientation"
        
        // Check the current view controller's identifier
        if let currentIdentifier = restorationIdentifier {
            if currentIdentifier == "ImageVC" {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .search, target: self, action: #selector(seatchImages))
            }
        }
        
        
    }

    @objc func seatchImages() {
        
    }

}

