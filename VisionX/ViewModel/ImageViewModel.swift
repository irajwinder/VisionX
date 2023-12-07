//
//  SearchImageViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/3/23.
//

import Foundation

protocol LoadNextPageDelegate: AnyObject {
    func didLoadNextPage()
}
protocol BookmarkDelegate: AnyObject {
    func didAddBookmark(_ relativePath: String?)
}

protocol PhotoSearchDelegate: AnyObject {
    func didSearchPhotos(_ response: PhotoResponse?)
}

protocol LoadOriginalImageDelegate: AnyObject {
    func didLoadOriginalImage()
}

protocol ImageLoadingDelegate: AnyObject {
    func didLoadImageData(_ imageData: Data?,_ indexPath: IndexPath)
}

class ImageViewModel {
    weak var delegate: LoadNextPageDelegate?
    weak var bookmarkDelegate: BookmarkDelegate?
    weak var photoSearchDelegate: PhotoSearchDelegate?
    weak var loadOriginalImageDelegate: LoadOriginalImageDelegate?
    weak var imageLoadingDelegate: ImageLoadingDelegate?
    
    var photos: [Photo] = []
    var response: PhotoResponse?
    var query: String = ""
    var currentPage: Int = 1
    var perPage: Int = 0
    var totalPages: Int = 0
    
    var selectedPhoto: Photo?
    var imageData: Data?
    
    func loadNextPage() {
        // Increment the current page
        currentPage += 1
        
        // Call the API to fetch the next page of photos
        networkManagerInstance.searchPhotos(query: query, perPage: perPage, page: currentPage) { [weak self] response in
            guard let self = self else { return }
            
            // Check if there are new photos
            if let newPhotos = response?.photos {
                // Append the new photos to the existing photos array
                self.photos.append(contentsOf: newPhotos)
            }
            self.delegate?.didLoadNextPage()
        }
    }
    
    func addBookmark(_ photo: Photo) {
        // Download the image
        if let imageUrl = URL(string: photo.src.tiny) {
            networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                // Check if imageData is not nil
                if let imageData = imageData {
                    // Save the image to the file manager
                    if let relativePath = fileManagerClassInstance.saveImageToFileManager(imageData: imageData, photo: photo) {
                        self.bookmarkDelegate?.didAddBookmark(relativePath)
                    } else {
                        self.bookmarkDelegate?.didAddBookmark(nil)
                    }
                } else {
                    self.bookmarkDelegate?.didAddBookmark(nil)
                }
            }
        }
    }
    
    func loadImage(for photo: Photo,at indexPath: IndexPath) {
        // Check if the image is already in the cache
        if let cachedImageData = cacheManagerInstance.getImageData(forKey: photo.src.tiny) {
            print("Image loaded from cache")
            imageLoadingDelegate?.didLoadImageData(cachedImageData, indexPath)
        } else {
            print("Downloading image from network")
            // If not, download the image and store it in the cache
            if let imageUrl = URL(string: photo.src.tiny) {
                networkManagerInstance.downloadImage(from: imageUrl) { imageData in
                    // Check if imageData is not nil
                    if let imageData = imageData {
                        // Store the downloaded image data in the cache
                        cacheManagerInstance.setImageData(imageData, forKey: photo.src.tiny)
                        self.imageLoadingDelegate?.didLoadImageData(imageData, indexPath)
                    } else {
                        self.imageLoadingDelegate?.didLoadImageData(nil, indexPath)
                    }
                    
                }
            }
        }
    }
    
    func searchPhotos(query: String, perPage: Int, page: Int) {
        networkManagerInstance.searchPhotos(query: query, perPage: perPage, page: page) { [weak self] response in
            guard let self = self else { return }
            self.photoSearchDelegate?.didSearchPhotos(response)
        }
    }
    
    func loadOriginalImage() {
        guard let photo = selectedPhoto, let imageUrl = URL(string: photo.src.original) else {
            loadOriginalImageDelegate?.didLoadOriginalImage()
            return
        }
        
        // Download the image data
        networkManagerInstance.downloadImage(from: imageUrl) { [weak self] imageData in
            // Update the imageData property
            self?.imageData = imageData
            self?.loadOriginalImageDelegate?.didLoadOriginalImage()
        }
    }
}
