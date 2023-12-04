//
//  ShowImageDetailVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/4/23.
//

import UIKit

class ShowImageDetailVC: UIViewController {
    
    @IBOutlet weak var originalImage: UIImageView!
    
    var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Image Details"
        
        // Load the original image in the UIImageView
        loadImage()
    }
    
    func loadImage() {
        if let photo = selectedPhoto, let imageUrl = URL(string: photo.src.original) {
            // Download the image
            networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        self.originalImage.image = image
                    }
                }
            }
        }
    }
}
