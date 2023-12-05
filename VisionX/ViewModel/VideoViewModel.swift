//
//  VideoViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/4/23.
//

import Foundation

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
}
