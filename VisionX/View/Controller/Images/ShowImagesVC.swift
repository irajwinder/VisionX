//
//  ShowImagesVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class ShowImagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var viewModel = SearchImageViewModel()
    
    @IBOutlet weak var currentpageLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Images"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let response = viewModel.response else {
            return
        }
        viewModel.perPage = response.per_page
        viewModel.totalPages = response.total_results
        self.currentpageLabel.text = String("Current Page: \(response.page)")
        self.totalPagesLabel.text = String("Total Pages: \(viewModel.totalPages)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImagesTableViewCell
        let photo = viewModel.photos[indexPath.row]
        
        // Check if the image is already in the cache
        if let cachedImage = networkManagerInstance.getImage(forKey: photo.src.tiny) {
            print("Image loaded from cache")
            cell.ImagesCell.image = cachedImage
        } else {
            print("Downloading image from network")
            // If not, download the image and store it in the cache
            if let imageUrl = URL(string: photo.src.tiny) {
                networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                    // Check if imageData is not nil and Convert data to UIImage
                    if let imageData = imageData, let image = UIImage(data: imageData) {
                        // Store the downloaded image in the cache
                        networkManagerInstance.setImage(image, forKey: photo.src.tiny)
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
        let selectedPhoto = viewModel.photos[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = viewModel.photos.count - 1
        // Check if the last cell is about to be displayed
        if indexPath.row == lastRowIndex {
            // Check if there are more pages to load
            if viewModel.currentPage < viewModel.totalPages {
                // Load the next page of photos
                loadNextPage()
            }
        }
    }
    
    func loadNextPage() {
        // Increment the current page
        viewModel.currentPage += 1
        
        // Make a network request to search for photos for the next page
        networkManagerInstance.searchPhotos(query: viewModel.query, perPage: viewModel.perPage, page: viewModel.currentPage) { [weak self] response in
            // Capture a weak reference to self to avoid strong reference cycles
            guard let self = self else { return }
            
            // Check if there are new photos
            if let newPhotos = response?.photos {
                // Append the new photos to the existing photos array
                self.viewModel.photos.append(contentsOf: newPhotos)
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.currentpageLabel.text = String("Current Page: \(self.viewModel.currentPage)")
                }
            }
        }
    }
}
