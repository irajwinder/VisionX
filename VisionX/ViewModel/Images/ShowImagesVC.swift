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
    
    @IBAction func imageBookmark(_ sender: UIButton) {
        // Gets the index path of the cell containing the button
        if let cell = sender.superview?.superview as? ImagesTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            
            // Get the corresponding photo
            let photo = photos[indexPath.row]
            
            // Save the image using fileManagerClassInstance
            fileManagerClassInstance.saveImage(photo: photo) { relativePath in
                guard let relativePath = relativePath else {
                    print("Error saving image to FileManager.")
                    return
                }
                
                // Save image link to CoreData
                DispatchQueue.main.async {
                    datamanagerInstance.saveBookmark(bookmarkURL: relativePath)
                }
            }
        }
        
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
        return cell
    }
}
