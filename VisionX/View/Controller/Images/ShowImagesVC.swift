//
//  ShowImagesVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//

import UIKit

class ShowImagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, LoadNextPageDelegate,BookmarkDelegate, ImageLoadingDelegate {
    var viewModel = ImageViewModel()
    
    @IBOutlet weak var currentpageLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Images"
        
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
        viewModel.bookmarkDelegate = self
        viewModel.imageLoadingDelegate = self
        
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
        
        viewModel.loadImage(for: photo, at: indexPath)
        cell.imageBookmark.tag = indexPath.row
        cell.imageBookmark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addBookmark(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedPhoto = viewModel.photos[indexPath.row]
        
        viewModel.addBookmark(selectedPhoto)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = viewModel.photos[indexPath.row]
        
        let showImageDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowImageDetailVC") as! ShowImageDetailVC
        showImageDetailVC.viewModel.selectedPhoto = selectedPhoto
        self.navigationController?.pushViewController(showImageDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = viewModel.photos.count - 1
        // Check if the last cell is about to be displayed
        if indexPath.row == lastRowIndex {
            // Check if there are more pages to load
            if viewModel.currentPage < viewModel.totalPages {
                // Load the next page of photos
                viewModel.loadNextPage()
            }
        }
    }
    
    func didAddBookmark(_ relativePath: String?) {
        // Check if relativePath is not nil
        if let relativePath = relativePath {
            DispatchQueue.main.async {
                // Save image link to CoreData
                datamanagerInstance.saveBookmark(imageURL: relativePath, videoURL: "")
                Validation.showAlert(on: self, with: "Success", message: "Image Bookmarked Successfully.")
            }
        } else {
            print("Error saving image to FileManager.")
        }
    }
    
    func didLoadNextPage() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.currentpageLabel.text = String("Current Page: \(self.viewModel.currentPage)")
        }
    }
    
    func didLoadImageData(_ imageData: Data?, _ indexPath: IndexPath) {
        guard let imageData = imageData else { return }
        // Convert the image data to UIImage
        let image = UIImage(data: imageData)
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: indexPath) as? ImagesTableViewCell {
                cell.ImagesCell.image = image
            }
        }
    }
}
