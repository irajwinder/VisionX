//
//  SearchVideoVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class SearchVideoVC: UIViewController {
    var viewModel = VideoViewModel()
    
    @IBOutlet weak var videoText: UITextField!
    @IBOutlet weak var perPageSlider: UISlider!
    @IBOutlet weak var numberText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search Videos"
        
        // Set initial value for numberLabel
        numberText.text = "\(Int(perPageSlider.value))"
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        numberText.text = "\(Int(perPageSlider.value))"
    }
    
    @IBAction func searchVideos(_ sender: Any) {
        guard let query = videoText.text, Validation.isValidName(query) else {
            Validation.showAlert(on: self, with: "Invalid Name", message: "Please enter a valid name.")
            return
        }
        
        guard let numberText = numberText.text, Validation.isValidNumber(Int(numberText)) else {
            Validation.showAlert(on: self, with: "Invalid Number", message: "Please select Per Page Result.")
            return
        }
        
        networkManagerInstance.searchVideos(query: query, perPage: Int(numberText)!, page: 1) { response in
            guard let response = response else {
                return
            }
            DispatchQueue.main.async {
                let showImagesVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowVideosVC") as! ShowVideosVC
                showImagesVC.viewModel.videos = response.videos
                showImagesVC.viewModel.query = query
                showImagesVC.viewModel.response = response
                self.navigationController?.pushViewController(showImagesVC, animated: true)
            }
        }
    }
}
