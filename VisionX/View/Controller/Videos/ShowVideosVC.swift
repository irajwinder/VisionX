//
//  ShowVideosVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/28/23.
//

import UIKit

class ShowVideosVC: UIViewController, UITableViewDataSource, UITableViewDelegate, LoadNextPageDelegate, LoadNextVideosPageDelegate, VideoBookmarkDelegate, VideoImageLoadingDelegate {
    var viewModel = VideoViewModel()
    
    @IBOutlet weak var currentpageLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var videoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Videos"
        
        videoTableView.dataSource = self
        videoTableView.delegate = self
        viewModel.loadNextVideosPageDelegate = self
        viewModel.videoBookmarkDelegate = self
        viewModel.videoImageLoadingDelegate = self
        
        guard let response = viewModel.response else {
            return
        }
        self.viewModel.perPage = response.per_page
        self.viewModel.totalPages = response.total_results
        self.currentpageLabel.text = String("Current Page: \(response.page)")
        self.totalPagesLabel.text = String("Total Pages: \(viewModel.totalPages)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideosTableViewCell
        // Get the video data for the current row
        let video = viewModel.videos[indexPath.row]
        
        viewModel.loadImage(for: video, at: indexPath)
        cell.VideosBookmark.tag = indexPath.row
        cell.VideosBookmark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVideo = viewModel.videos[indexPath.row]
        
        if let firstVideoFile = selectedVideo.video_files.first,
           let videoURL = URL(string: firstVideoFile.link) {
            // Call the playVideo method from the VideoPlayer class
            videoManagerInstance.playVideo(videoURL: videoURL, viewController: self)
        }
    }
    
    @objc func addBookmark(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedVideo = viewModel.videos[indexPath.row]
        
        viewModel.addBookmark(for: selectedVideo)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = viewModel.videos.count - 1
        // Check if the last cell is about to be displayed
        if indexPath.row == lastRowIndex {
            // Check if there are more pages to load
            if viewModel.currentPage < viewModel.totalPages {
                // Load the next page of photos
                viewModel.loadNextPage()
            }
        }
    }
    
    func didLoadNextPage() {
        // Update UI on the main thread
        DispatchQueue.main.async {
            self.videoTableView.reloadData()
            self.currentpageLabel.text = String("Current Page: \(self.viewModel.currentPage)")
        }
    }
    
    func didAddBookmark(_ imageURL: String?, _ videoURL: String?) {
        // Check if imageURL and videoURL is not nil
        if let imageURL = imageURL, let videoURL = videoURL {
            DispatchQueue.main.async {
                // Save image and video link to CoreData
                datamanagerInstance.saveBookmark(imageURL: imageURL, videoURL: videoURL)
                Validation.showAlert(on: self, with: "Success", message: "Video Bookmarked Successfully.")
            }
        } else {
            print("Error saving video or image to FileManager.")
        }
    }
    
    func didLoadImageData(_ imageData: Data?, _ indexPath: IndexPath) {
        guard let imageData = imageData else { return }
        // Convert the image data to UIImage
        let image = UIImage(data: imageData)
        DispatchQueue.main.async {
            if let cell = self.videoTableView.cellForRow(at: indexPath) as? VideosTableViewCell {
                cell.VideosCell.image = image
            }
        }
    }
}
