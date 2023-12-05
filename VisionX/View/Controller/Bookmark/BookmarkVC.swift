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
        if let imageData = fileManagerClassInstance.loadImageDataFromFileManager(relativePath: bookmark.imageURL ?? "") {
            let uiImage = UIImage(data: imageData)
            cell.BookmarksCell.image = uiImage
        } else {
            print("Failed to create UIImage from data")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBookmark = viewModel.bookmarks[indexPath.row]
        
        // Check if the bookmark has a video URL
        guard let videoURL = fileManagerClassInstance.loadURLFromFileManager(relativePath: selectedBookmark.videoURL ?? "") else {
            // Handle the case when there is no video URL
            return
        }
        
        // Check if the video is playable
        if AVURLAsset(url: videoURL).isPlayable {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Handle the deletion when the user swipes to delete
            let selectedBookmark = viewModel.bookmarks[indexPath.row]
            
            // Delete the corresponding image file from the file manager
            if let imageURL = selectedBookmark.imageURL {
                fileManagerClassInstance.deleteImageFromFileManager(relativePath: imageURL)
            }
            
            // Delete the corresponding video file from the file manager
            if let bookmarkVideoURL = selectedBookmark.videoURL, !bookmarkVideoURL.isEmpty {
                fileManagerClassInstance.deleteImageFromFileManager(relativePath: bookmarkVideoURL)
            }
            
            // Delete the bookmark entity from Core Data
            datamanagerInstance.deleteEntity(selectedBookmark)
            
            // Remove the bookmark from the local array
            viewModel.bookmarks.remove(at: indexPath.row)
            
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
