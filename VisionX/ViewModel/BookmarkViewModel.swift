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
}
