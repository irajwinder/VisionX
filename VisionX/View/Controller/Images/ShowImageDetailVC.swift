//
//  ShowImageDetailVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/4/23.
//

import UIKit

class ShowImageDetailVC: UIViewController, LoadOriginalImageDelegate {
    var viewModel = ImageViewModel()
    
    @IBOutlet weak var originalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Image Details"
        viewModel.loadOriginalImageDelegate = self
        viewModel.loadOriginalImage()
    }
    
    func didLoadOriginalImage() {
        if let imageData = self.viewModel.imageData, let image = UIImage(data: imageData) {
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.originalImage.image = image
            }
        }
    }
}
