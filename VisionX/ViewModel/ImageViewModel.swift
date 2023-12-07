//
//  SearchImageViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/3/23.
//

import Foundation

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
    
    func addBookmark(for photo: Photo, completion: @escaping (String?) -> Void) {
        // Download the image
        if let imageUrl = URL(string: photo.src.tiny) {
            networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                // Check if imageData is not nil
                if let imageData = imageData {
                    // Save the image to the file manager
                    if let relativePath = fileManagerClassInstance.saveImageToFileManager(imageData: imageData, photo: photo) {
                        completion(relativePath)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func loadImage(for photo: Photo, completion: @escaping (Data?) -> Void) {
        // Check if the image is already in the cache
        if let cachedImageData = cacheManagerInstance.getImageData(forKey: photo.src.tiny) {
            print("Image loaded from cache")
            completion(cachedImageData)
        } else {
            print("Downloading image from network")
            // If not, download the image and store it in the cache
            if let imageUrl = URL(string: photo.src.tiny) {
                networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                    // Check if imageData is not nil
                    if let imageData = imageData {
                        // Store the downloaded image data in the cache
                        cacheManagerInstance.setImageData(imageData, forKey: photo.src.tiny)
                        // Pass the image data to the completion block
                        completion(imageData)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func searchPhotos(query: String, perPage: Int, page: Int, completion: @escaping (PhotoResponse?) -> Void) {
        networkManagerInstance.searchPhotos(query: query, perPage: perPage, page: page) { response in
            completion(response)
        }
    }
    
    func loadOriginalImage(completion: @escaping () -> Void) {
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
}
