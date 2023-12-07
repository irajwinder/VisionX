//
//  BookmarkViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/4/23.
//

import Foundation

class BookmarkViewModel {
    var bookmarks: [Bookmark] = []
    
    func fetchBookmarks() {
        let fetch = datamanagerInstance.fetchBookmark()
        self.bookmarks = fetch
    }
    
    func loadImageData(forBookmark bookmark: Bookmark) -> Data? {
        return fileManagerClassInstance.loadImageDataFromFileManager(relativePath: bookmark.imageURL ?? "")
    }
    
    func videoURL(forBookmark bookmark: Bookmark) -> URL? {
        return fileManagerClassInstance.loadURLFromFileManager(relativePath: bookmark.videoURL ?? "")
    }
    
    func deleteBookmark(forBookmark bookmark: Bookmark) {
        // Delete the corresponding image file from the file manager
        if let imageURL = bookmark.imageURL {
            fileManagerClassInstance.deleteImageFromFileManager(relativePath: imageURL)
        }
        // Delete the corresponding video file from the file manager
        if let bookmarkVideoURL = bookmark.videoURL, !bookmarkVideoURL.isEmpty {
            fileManagerClassInstance.deleteImageFromFileManager(relativePath: bookmarkVideoURL)
        }
        // Delete the bookmark entity from Core Data
        datamanagerInstance.deleteEntity(bookmark)
    }
}
