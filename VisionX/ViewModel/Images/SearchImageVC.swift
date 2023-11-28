//
//  SearchImageVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/27/23.
//

import UIKit
                               
class SearchImageVC: UIViewController {
    
    @IBOutlet weak var imageText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search Pictures"
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    @IBAction func searchImages(_ sender: Any) {
        guard let query = imageText.text, Validation.isValidName(query) else {
            Validation.showAlert(on: self, with: "Invalid Name", message: "Please enter a valid name.")
            return
        }
        
        networkManagerInstance.searchPhotos(query: query, perPage: 15) { response in
            guard let response = response else {
                return
            }
            DispatchQueue.main.async {
                let showImagesVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowImagesVC") as! ShowImagesVC
                showImagesVC.photos = response.photos
                self.navigationController?.pushViewController(showImagesVC, animated: true)
            }
        }
    }
}
