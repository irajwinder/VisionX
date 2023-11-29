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
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideosTableViewCell
        // Get the video data for the current row
        let video = videos[indexPath.row]
        
        // Download the image
        if let imageUrl = URL(string: video.image) {
            networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                // Check if imageData is not nil
                if let imageData = imageData {
                    // Convert data to UIImage
                    if let image = UIImage(data: imageData) {
                        // Update the cell's image on the main thread
                        DispatchQueue.main.async {
                            cell.VideosCell.image = image
                        }
                    }
                }
            }
        }
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
}
