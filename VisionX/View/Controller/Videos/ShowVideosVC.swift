//
//  ShowVideosVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/28/23.
//

import UIKit
import AVKit

class ShowVideosVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewModel = VideoViewModel()
    
    @IBOutlet weak var currentpageLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var videoTableView: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear image cache when leaving the ShowVideosVC
        networkManagerInstance.clearImageCache()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Videos"
        
        videoTableView.dataSource = self
        videoTableView.delegate = self
        
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
        
        viewModel.loadImage(for: video) { image in
            // Set the cell's image on the main thread
            DispatchQueue.main.async {
                cell.VideosCell.image = image
            }
        }
        //        // Load the first video picture asynchronously
        //        if let firstVideoPicture = video.video_pictures.first, let imageUrl = URL(string: firstVideoPicture.picture) {
        //            // Check if the image is already in the cache
        //            if let cachedImage = networkManagerInstance.getImage(forKey: imageUrl.absoluteString) {
        //                print("Image loaded from cache")
        //                cell.VideosCell.image = cachedImage
        //            } else {
        //                print("Downloading image from network")
        //                // If not, download the image and store it in the cache
        //                networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
        //                    // Check if videoImageData is not nil and Convert data to UIImage
        //                    if let videoImageData = videoImageData, let videoImage = UIImage(data: videoImageData) {
        //                        // Store the downloaded image in the cache
        //                        networkManagerInstance.setImage(videoImage, forKey: imageUrl.absoluteString)
        //                        // Update the cell's image on the main thread
        //                        DispatchQueue.main.async {
        //                            cell.VideosCell.image = videoImage
        //                        }
        //                    }
        //                }
        //            }
        //        }
        cell.VideosBookmark.tag = indexPath.row
        cell.VideosBookmark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVideo = viewModel.videos[indexPath.row]
        
        // Loop through video files
        for videoFile in selectedVideo.video_files {
            let videoURL = URL(string: videoFile.link)
            
            // Check if the videoURL is valid
            if let videoURL = videoURL {
                // Create an AVPlayer with the video URL
                let player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                // Present the AVPlayerViewController and start playing the video
                present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
    
    @objc func addBookmark(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedVideo = viewModel.videos[indexPath.row]
        
        viewModel.addBookmark(for: selectedVideo) { imageURL, videoURL in
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
        
        //        // Download the video
        //        if let firstVideoFile = selectedVideo.video_files.first, let videoUrl = URL(string: firstVideoFile.link) {
        //            networkManagerInstance.downloadImage(from: videoUrl) { videoData in
        //                // Check if videoData is not nil
        //                if let videoData = videoData {
        //                    // Load the first video picture
        //                    if let firstVideoPicture = selectedVideo.video_pictures.first,
        //                       let imageUrl = URL(string: firstVideoPicture.picture) {
        //
        //                        networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
        //                            // Check if videoImageData is not nil
        //                            if let videoImageData = videoImageData {
        //                                // Save the video and image to the file manager
        //                                let urls = fileManagerClassInstance.saveVideoToFileManager(videoData: videoData, video: selectedVideo, videoImage: videoImageData)
        //
        //                                if let videoURL = urls.videoURL, let imageURL = urls.imageURL {
        //                                    // Save video and image links to CoreData
        //                                    DispatchQueue.main.async {
        //                                        datamanagerInstance.saveBookmark(imageURL: imageURL, videoURL: videoURL)
        //
        //                                        // Show alert on the main thread
        //                                        Validation.showAlert(on: self, with: "Success", message: "Video Bookmarked Successfully.")
        //                                    }
        //                                } else {
        //                                    print("Error saving video or image to FileManager.")
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = viewModel.videos.count - 1
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
        viewModel.loadNextPage {
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.videoTableView.reloadData()
                self.currentpageLabel.text = String("Current Page: \(self.viewModel.currentPage)")
            }
        }
    }
}
