//
//  SearchImageVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/27/23.
//

import UIKit

//class SearchImageViewModel {
//    var orientationOptions: [String] = ["landscape", "portrait", "square"]
//    var localeOptions: [String] = ["en-US", "pt-BR", "es-ES", "ca-ES", "de-DE", "it-IT", "fr-FR", "sv-SE", "id-ID", "pl-PL", "ja-JP", "zh-TW", "zh-CN", "ko-KR", "th-TH", "nl-NL", "hu-HU", "vi-VN", "cs-CZ", "da-DK", "fi-FI", "uk-UA", "el-GR", "ro-RO", "nb-NO", "sk-SK", "tr-TR", "ru-RU"]
//    
//    var selectedLocale: String
//    var selectedOrientation: String
//    var selectedPerPage: Int = 15
//
//    init() {
//        // Sets default values for selectedLocale and selectedOrientation
//        selectedLocale = localeOptions.first ?? "en-US"
//        selectedOrientation = orientationOptions.first ?? "landscape"
//    }
//
//    func updateSelectedLocale(index: Int) {
//        selectedLocale = localeOptions[index]
//    }
//
//    func updateSelectedOrientation(index: Int) {
//        selectedOrientation = orientationOptions[index]
//    }
//}
                               
class SearchImageVC: UIViewController {
    
    @IBOutlet weak var imageText: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose Orientation"
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    @IBAction func searchImages(_ sender: Any) {
        guard let query = imageText.text, Validation.isValidName(query) else {
                Validation.showAlert(on: self, with: "Invalid Name", message: "Please enter a valid name.")
                return
            }

            apiManagerInstance.searchPhotos(query: query, perPage: 5) { response in
                guard let response = response else {
                    return
                }

                // Create an empty array to store relative paths
                var relativePaths: [String] = []

                // Iterate through photos, save to file manager, and update the photos array
                for photo in response.photos {
                    fileManagerClassInstance.saveImage(photo: photo) { relativePath in
                        // Append the relative path to the array
                        if let relativePath = relativePath {
                            relativePaths.append(relativePath)
                        }

                        // Check if all relative paths are collected before navigating to the next view controller
                        if relativePaths.count == response.photos.count {
                            DispatchQueue.main.async {
                                let showImagesVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowImagesVC") as! ShowImagesVC
                                showImagesVC.photos = relativePaths
                                self.navigationController?.pushViewController(showImagesVC, animated: true)
                            }
                        }
                    }
                }
            }
    }
}
