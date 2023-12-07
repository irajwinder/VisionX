//
//  VideoViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/4/23.
//

import Foundation

protocol LoadNextVideosPageDelegate: AnyObject {
    func didLoadNextPage()
}

protocol VideoBookmarkDelegate: AnyObject {
    func didAddBookmark(_ imageURL: String?,_ videoURL: String?)
}

protocol VideoSearchDelegate: AnyObject {
    func didSearchVideos(_ response: VideoResponse?)
}

protocol VideoImageLoadingDelegate: AnyObject {
    func didLoadImageData(_ imageData: Data?,_ indexPath: IndexPath)
}

class VideoViewModel {
    weak var loadNextVideosPageDelegate: LoadNextVideosPageDelegate?
    weak var videoBookmarkDelegate: VideoBookmarkDelegate?
    weak var videoSearchDelegate: VideoSearchDelegate?
    weak var videoImageLoadingDelegate: VideoImageLoadingDelegate?
    
    var videos: [Video] = []
    var response: VideoResponse?
    var query: String = ""
    var currentPage: Int = 1
    var perPage: Int = 0
    var totalPages: Int = 0
    
    func loadNextPage() {
        // Increment the current page
        currentPage += 1
        
        // Call the API to fetch the next page of videos
        networkManagerInstance.searchVideos(query: query, perPage: perPage, page: currentPage) { [weak self] response in
            guard let self = self else { return }
            
            // Check if there are new videos
            if let newVideos = response?.videos {
                // Append the new video to the existing videos array
                self.videos.append(contentsOf: newVideos)
            }
            self.loadNextVideosPageDelegate?.didLoadNextPage()
        }
    }
    
    func addBookmark(for video: Video) {
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
                                    self.videoBookmarkDelegate?.didAddBookmark(imageURL, videoURL)
                                } else {
                                    self.videoBookmarkDelegate?.didAddBookmark(nil, nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Method to load image asynchronously
    func loadImage(for video: Video, at indexPath: IndexPath) {
        if let firstVideoPicture = video.video_pictures.first, let imageUrl = URL(string: firstVideoPicture.picture) {
            // Check if the image is already in the cache
            if let cachedImageData = cacheManagerInstance.getImageData(forKey: imageUrl.absoluteString) {
                print("Image loaded from cache")
                videoImageLoadingDelegate?.didLoadImageData(cachedImageData, indexPath)
            } else {
                print("Downloading image from network")
                // If not, download the image and store it in the cache
                networkManagerInstance.downloadImage(from: imageUrl) { videoImageData in
                    // Check if videoImageData is not nil
                    if let videoImageData = videoImageData {
                        // Store the downloaded image in the cache
                        cacheManagerInstance.setImageData(videoImageData, forKey: imageUrl.absoluteString)
                        // Pass the image data to the completion block
                        self.videoImageLoadingDelegate?.didLoadImageData(videoImageData, indexPath)
                    } else {
                        self.videoImageLoadingDelegate?.didLoadImageData(nil, indexPath)
                    }
                }
            }
        }
    }
    
    func searchVideos(query: String, perPage: Int, page: Int) {
        networkManagerInstance.searchVideos(query: query, perPage: perPage, page: page) { [weak self] response in
            guard let self = self else { return }
            self.videoSearchDelegate?.didSearchVideos(response)
        }
    }
}
