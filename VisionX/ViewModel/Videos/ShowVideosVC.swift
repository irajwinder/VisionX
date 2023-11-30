//
//  ShowVideosVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/28/23.
//

import UIKit
import AVKit

class ShowVideosVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var videoTableView: UITableView!
    
    var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Videos"
        
        videoTableView.dataSource = self
        videoTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideosTableViewCell
        // Get the video data for the current row
        let video = videos[indexPath.row]
        
        // Loop through video pictures and download images asynchronously
        for videoPicture in video.video_pictures {
            let pictureLink = videoPicture.picture
            
            // Download the image
            if let imageUrl = URL(string: pictureLink) {
                networkManagerInstance.downloadImage(from: imageUrl) { videoData in
                    // Check if imageData is not nil
                    if let videoData = videoData {
                        // Convert data to UIImage
                        if let videoImage = UIImage(data: videoData) {
                            // Update the cell's image on the main thread
                            DispatchQueue.main.async {
                                cell.VideosCell.image = videoImage
                            }
                        }
                    }
                }
            }
        }
        
        cell.videoBookmark.tag = indexPath.row
        cell.videoBookmark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
        
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
        
        guard let firstVideoFile = selectedVideo.video_files.first else {
            return
        }

        // Download the video
        if let videoUrl = URL(string: firstVideoFile.link) {
            networkManagerInstance.downloadImage(from: videoUrl) { videoData in
                // Check if videoData is not nil
                if let videoData = videoData {
                    // Save the video to the file manager
                    if let relativePath = fileManagerClassInstance.saveVideoToFileManager(videoData: videoData, video: selectedVideo) {
                        // Save video link to CoreData
                        DispatchQueue.main.async {
                            datamanagerInstance.saveBookmark(bookmarkURL: relativePath)
                            
                            // Show alert on the main thread
                            Validation.showAlert(on: self, with: "Success", message: "Video Bookmarked Successfully.")
                        }
                    } else {
                        print("Error saving video to FileManager.")
                    }
                }
            }
        }
    }
}
