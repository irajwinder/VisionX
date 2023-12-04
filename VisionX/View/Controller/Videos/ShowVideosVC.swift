//
//  ShowVideosVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/28/23.
//

import UIKit
import AVKit

class ShowVideosVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currentpageLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var videoTableView: UITableView!
    
    var videos: [Video] = []
    var response: VideoResponse?
    var query: String = ""
    var currentPage: Int = 1
    var perPage: Int = 0
    var totalPages: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Videos"
        
        videoTableView.dataSource = self
        videoTableView.delegate = self
        
        guard let response = response else {
            return
        }
        self.perPage = response.per_page
        self.totalPages = response.total_results
        self.currentpageLabel.text = String("Current Page: \(response.page)")
        self.totalPagesLabel.text = String("Total Pages: \(totalPages)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideosTableViewCell
//        // Get the video data for the current row
//        let video = videos[indexPath.row]
//        
//        // Load the first video picture asynchronously
//        if let firstVideoPicture = video.video_pictures.first, let imageUrl = URL(string: firstVideoPicture.picture) {
//            networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
//                // Check if videoImageData is not nil
//                if let videoImageData = videoImageData {
//                    // Convert data to UIImage
//                    if let videoImage = UIImage(data: videoImageData) {
//                        // Update the cell's image on the main thread
//                        DispatchQueue.main.async {
//                            cell.VideosCell.image = videoImage
//                        }
//                    }
//                }
//            }
//        }
//        
//        cell.VideosBookmark.tag = indexPath.row
//        cell.VideosBookmark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideosTableViewCell
        // Get the video data for the current row
        let video = videos[indexPath.row]
        
        // Load the first video picture asynchronously
        if let firstVideoPicture = video.video_pictures.first, let imageUrl = URL(string: firstVideoPicture.picture) {
            // Check if the image is already in the cache
            if let cachedImage = networkManagerInstance.getImage(forKey: imageUrl.absoluteString) {
                print("Image loaded from cache")
                cell.VideosCell.image = cachedImage
            } else {
                print("Downloading image from network")
                // If not, download the image and store it in the cache
                networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
                    // Check if videoImageData is not nil and Convert data to UIImage
                    if let videoImageData = videoImageData, let videoImage = UIImage(data: videoImageData) {
                        // Store the downloaded image in the cache
                        networkManagerInstance.setImage(videoImage, forKey: imageUrl.absoluteString)
                        // Update the cell's image on the main thread
                        DispatchQueue.main.async {
                            cell.VideosCell.image = videoImage
                        }
                    }
                }
            }
        }
        cell.VideosBookmark.tag = indexPath.row
        cell.VideosBookmark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVideo = videos[indexPath.row]
        
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
        let selectedVideo = videos[indexPath.row]
        
        // Download the video
        if let firstVideoFile = selectedVideo.video_files.first, let videoUrl = URL(string: firstVideoFile.link) {
            networkManagerInstance.downloadImage(from: videoUrl) { videoData in
                // Check if videoData is not nil
                if let videoData = videoData {
                    // Load the first video picture
                    if let firstVideoPicture = selectedVideo.video_pictures.first,
                       let imageUrl = URL(string: firstVideoPicture.picture) {
                        
                        networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
                            // Check if videoImageData is not nil
                            if let videoImageData = videoImageData {
                                // Save the video and image to the file manager
                                let urls = fileManagerClassInstance.saveVideoToFileManager(videoData: videoData, video: selectedVideo, videoImage: videoImageData)
                                
                                if let videoURL = urls.videoURL, let imageURL = urls.imageURL {
                                    // Save video and image links to CoreData
                                    DispatchQueue.main.async {
                                        datamanagerInstance.saveBookmark(imageURL: imageURL, videoURL: videoURL)
                                        
                                        // Show alert on the main thread
                                        Validation.showAlert(on: self, with: "Success", message: "Video Bookmarked Successfully.")
                                    }
                                } else {
                                    print("Error saving video or image to FileManager.")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = videos.count - 1
        // Check if the last cell is about to be displayed
        if indexPath.row == lastRowIndex {
            // Check if there are more pages to load
            if currentPage < totalPages {
                // Load the next page of photos
                loadNextPage()
            }
        }
    }
    
    func loadNextPage() {
        // Increment the current page
        currentPage += 1
        
        // Call the API to fetch the next page of videos
        networkManagerInstance.searchVideos(query: query, perPage: perPage, page: currentPage) { [weak self] response in
            // Capture a weak reference to self to avoid strong reference cycles and check if there are new videos
            guard let self = self, let newVideos = response?.videos else {
                return
            }
            
            // Append the new video to the existing videos array
            self.videos.append(contentsOf: newVideos)
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.videoTableView.reloadData()
                self.currentpageLabel.text = "Current Page: \(self.currentPage)"
            }
        }
    }
}