//
//  SearchImageViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/3/23.
//

import Foundation

//Business logic Not dependant on UI
class ImageViewModel {
    var photos: [Photo] = []
    var response: PhotoResponse?
    var query: String = ""
    var currentPage: Int = 1
    var perPage: Int = 0
    var totalPages: Int = 0
    
    var selectedPhoto: Photo?
    var imageData: Data?
    
    func loadNextPage(completion: @escaping () -> Void) {
        // Increment the current page
        currentPage += 1
        
        // Call the API to fetch the next page of photos
        networkManagerInstance.searchPhotos(query: query, perPage: perPage, page: currentPage) { response in
            // Check if there are new photos
            if let newPhotos = response?.photos {
                // Append the new photos to the existing photos array
                self.photos.append(contentsOf: newPhotos)
            }
            completion()
        }
    }
    
    func loadImage(completion: @escaping () -> Void) {
        guard let photo = selectedPhoto, let imageUrl = URL(string: photo.src.original) else {
            completion()
            return
        }
        // Download the image data
        networkManagerInstance.downloadImage(from: imageUrl) { imageData in
            // Update the imageData property
            self.imageData = imageData
            completion()
        }
    }
    
//    func addBookmark(for photo: Photo, completion: @escaping (Bool, String) -> Void) {
//        // Download the image
//        if let imageUrl = URL(string: photo.src.tiny) {
//            networkManagerInstance.downloadImage(from: imageUrl) { imageData in
//                // Check if imageData is not nil
//                if let imageData = imageData {
//                    // Save the image to the file manager
//                    if let relativePath = fileManagerClassInstance.saveImageToFileManager(imageData: imageData, photo: photo) {
//                        // Save image link to CoreData
//                        DispatchQueue.main.async {
//                            datamanagerInstance.saveBookmark(imageURL: relativePath, videoURL: "")
//                            completion(true, "Image Bookmarked Successfully.")
//                        }
//                    } else {
//                        completion(false, "Error saving image to FileManager.")
//                    }
//                }
//            }
//        }
//    }
}
