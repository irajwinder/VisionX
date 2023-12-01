//
//  BookmarkVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/28/23.
//

import UIKit
import AVKit

class BookmarkVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    var bookmarks: [Bookmark] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch bookmarks from Core Data
        let fetch = datamanagerInstance.fetchBookmark()
        self.bookmarks = fetch
        
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
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkTableViewCell
        let bookmark = bookmarks[indexPath.row]
        
        // Load bookmarked image
        if let imageData = fileManagerClassInstance.loadImageDataFromFileManager(relativePath: bookmark.imageURL ?? "") {
            let uiImage = UIImage(data: imageData)
            cell.BookmarksCell.image = uiImage
        } else {
            print("Failed to create UIImage from data")
        }
        
        //remove from bookmark
        cell.removeFromBookmark.tag = indexPath.row
        cell.removeFromBookmark.addTarget(self, action: #selector(removeFromBookmark), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBookmark = bookmarks[indexPath.row]
        
        // Check if the bookmark represents a video
        if let videoURL = fileManagerClassInstance.loadURLFromFileManager(relativePath: selectedBookmark.videoURL ?? "") {
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
    
    @objc func removeFromBookmark(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedBookmark = bookmarks[indexPath.row]
        
        //Delete the corresponding file from the file manager
        if let bookmarkURL = selectedBookmark.imageURL {
            fileManagerClassInstance.deleteImageFromFileManager(relativePath: bookmarkURL)
        }
        
        //Delete the bookmark entity from Core Data
        datamanagerInstance.deleteEntity(selectedBookmark)
        
        //Remove the bookmark from the local array
        bookmarks.remove(at: indexPath.row)
        bookmarkTableView.reloadData()
    }
}
