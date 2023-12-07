//
//  BookmarkVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/28/23.
//

import UIKit
import AVKit

class BookmarkVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewModel = BookmarkViewModel()
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch bookmarks from Core Data
        viewModel.fetchBookmarks()
        // Reload the table view data
        bookmarkTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bookmark"
        
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkTableViewCell
        let bookmark = viewModel.bookmarks[indexPath.row]
        
        // Load bookmarked image
        if let imageData = viewModel.loadImageData(forBookmark: bookmark) {
            let uiImage = UIImage(data: imageData)
            cell.BookmarksCell.image = uiImage
        } else {
            print("Failed to create UIImage from data")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBookmark = viewModel.bookmarks[indexPath.row]
        
        guard let videoURL = viewModel.videoURL(forBookmark: selectedBookmark) else {
            return
        }
        // Use the VideoManager to play the video
        videoManagerInstance.playVideo(videoURL: videoURL, viewController: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Handle the deletion when the user swipes to delete
            let selectedBookmark = viewModel.bookmarks[indexPath.row]
            
            viewModel.deleteBookmark(forBookmark: selectedBookmark)
            // Remove the bookmark from the local array
            viewModel.bookmarks.remove(at: indexPath.row)
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
