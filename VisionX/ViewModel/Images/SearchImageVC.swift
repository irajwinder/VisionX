//
//  SearchImageVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/27/23.
//

import UIKit
                               
class SearchImageVC: UIViewController {
    
    @IBOutlet weak var imageText: UITextField!
    @IBOutlet weak var perpageSlider: UISlider!
    @IBOutlet weak var numberLabel: UILabel!
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search Photos"
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        // Set initial value for numberLabel
        numberLabel.text = "\(Int(perpageSlider.value))"
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        numberLabel.text = "\(Int(perpageSlider.value))"
    }
    
    
    @IBAction func searchImages(_ sender: Any) {
        guard let query = imageText.text, Validation.isValidName(query) else {
            Validation.showAlert(on: self, with: "Invalid Name", message: "Please enter a valid name.")
            return
        }
        
        guard let numberLabel = numberLabel.text, Validation.isValidNumber(Int(numberLabel)) else {
            Validation.showAlert(on: self, with: "Invalid Number", message: "Please select Per Page Result.")
            return
        }
        
        networkManagerInstance.searchPhotos(query: query, perPage: Int(numberLabel)!, page: currentPage) { response in
            guard let response = response else {
                return
            }
            
            self.totalPages = response.total_results
            
            DispatchQueue.main.async {
                let showImagesVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowImagesVC") as! ShowImagesVC
                showImagesVC.photos = response.photos
                showImagesVC.currentPage = self.currentPage
                showImagesVC.totalPages = self.totalPages
                self.navigationController?.pushViewController(showImagesVC, animated: true)
            }
        }
    }
}
