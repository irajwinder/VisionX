//
//  ShowImageDetailVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/4/23.
//

import UIKit

class ShowImageDetailVC: UIViewController {
    var viewModel = ImageViewModel()
    
    @IBOutlet weak var originalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Image Details"
        loadImage()
    }
    
    // Load the original image in the UIImageView
    func loadImage() {
        viewModel.loadImage { [weak self] in
            if let imageData = self?.viewModel.imageData, let image = UIImage(data: imageData) {
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self?.originalImage.image = image
                }
            }
        }
    }
}
