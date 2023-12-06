//
//  VideoViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/4/23.
//

import Foundation
import UIKit

class VideoViewModel {
    var videos: [Video] = []
    var response: VideoResponse?
    var query: String = ""
    var currentPage: Int = 1
    var perPage: Int = 0
    var totalPages: Int = 0
    
    func loadNextPage(completion: @escaping () -> Void) {
        // Increment the current page
        currentPage += 1
        
        // Call the API to fetch the next page of videos
        networkManagerInstance.searchVideos(query: query, perPage: perPage, page: currentPage) { response in
            // Check if there are new videos
            if let newVideos = response?.videos {
                // Append the new video to the existing videos array
                self.videos.append(contentsOf: newVideos)
            }
            completion()
        }
    }
    
    func addBookmark(for video: Video, completion: @escaping (String?, String?) -> Void) {
        // Download the video
        if let firstVideoFile = video.video_files.first, let videoUrl = URL(string: firstVideoFile.link) {
            networkManagerInstance.downloadImage(from: videoUrl) { videoData in
                // Check if videoData is not nil
                if let videoData = videoData {
                    // Load the first video picture
                    if let firstVideoPicture = video.video_pictures.first,
                       let imageUrl = URL(string: firstVideoPicture.picture) {
                        
                        networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
                            // Check if videoImageData is not nil
                            if let videoImageData = videoImageData {
                                // Save the video and image to the file manager
                                let urls = fileManagerClassInstance.saveVideoToFileManager(videoData: videoData, video: video, videoImage: videoImageData)
                                if let imageURL = urls.imageURL, let videoURL = urls.videoURL {
                                    completion(imageURL, videoURL)
                                } else {
                                    completion(nil, nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Method to load image asynchronously
    func loadImage(for video: Video, completion: @escaping (UIImage?) -> Void) {
        if let firstVideoPicture = video.video_pictures.first, let imageUrl = URL(string: firstVideoPicture.picture) {
            // Check if the image is already in the cache
            if let cachedImage = networkManagerInstance.getImage(forKey: imageUrl.absoluteString) {
                print("Image loaded from cache")
                completion(cachedImage)
            } else {
                print("Downloading image from network")
                // If not, download the image and store it in the cache
                networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
                    // Check if videoImageData is not nil and convert data to UIImage
                    if let videoImageData = videoImageData, let videoImage = UIImage(data: videoImageData) {
                        // Store the downloaded image in the cache
                        networkManagerInstance.setImage(videoImage, forKey: imageUrl.absoluteString)
                        completion(videoImage)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func searchVideos(query: String, perPage: Int, page: Int, completion: @escaping (VideoResponse?) -> Void) {
        networkManagerInstance.searchVideos(query: query, perPage: perPage, page: page) { response in
            completion(response)
        }
    }
}
