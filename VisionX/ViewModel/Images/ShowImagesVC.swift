//
//  ShowImagesVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class ShowImagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Images"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImagesTableViewCell
        let photo = photos[indexPath.row]
        
        // Download the image
        if let imageUrl = URL(string: photo.src.tiny) {
            networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                // Check if imageData is not nil
                if let imageData = imageData {
                    // Convert data to UIImage
                    if let image = UIImage(data: imageData) {
                        // Update the cell's image on the main thread
                        DispatchQueue.main.async {
                            cell.ImagesCell.image = image
                        }
                    }
                }
            }
        }
        
        cell.imageBookmark.tag = indexPath.row
        cell.imageBookmark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addBookmark(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedPhoto = photos[indexPath.row]
        
        // Download the image
        if let imageUrl = URL(string: selectedPhoto.src.tiny) {
            networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                // Check if imageData is not nil
                if let imageData = imageData {
                    // Save the image to the file manager
                    if let relativePath = fileManagerClassInstance.saveImageToFileManager(imageData: imageData, photo: selectedPhoto) {
                        // Save image link to CoreData
                        DispatchQueue.main.async {
                            datamanagerInstance.saveBookmark(imageURL: relativePath, videoURL: "")
                            
                            // Show alert on the main thread
                            Validation.showAlert(on: self, with: "Success", message: "Image Bookmarked Successfully.")
                        }
                    } else {
                        print("Error saving image to FileManager.")
                    }
                }
            }
        }
    }
}
