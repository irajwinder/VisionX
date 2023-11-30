//
//  BookmarkVC.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/28/23.
//

import UIKit

class BookmarkVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    var bookmarks: [Bookmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bookmark"
        
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
        
        // Fetch bookmarks from Core Data
        let fetch = datamanagerInstance.fetchBookmark()
        self.bookmarks = fetch
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkTableViewCell
        let bookmark = bookmarks[indexPath.row]
        
        // Load bookmarked image
        let image = fileManagerClassInstance.loadImageFromFileManager(relativePath: bookmark.bookmarkURL ?? "")
        cell.BookmarksCell.image = image
        
        //remove from bookmark
        cell.removeFromBookmark.tag = indexPath.row
        cell.removeFromBookmark.addTarget(self, action: #selector(removeFromBookmark), for: .touchUpInside)
        return cell
    }
    
    @objc func removeFromBookmark(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedBookmark = bookmarks[indexPath.row]
        
        //Delete the corresponding file from the file manager
        if let bookmarkURL = selectedBookmark.bookmarkURL {
            fileManagerClassInstance.deleteImageFromFileManager(relativePath: bookmarkURL)
            //Delete the bookmark entity from Core Data
            datamanagerInstance.deleteEntity(selectedBookmark)
        }
        
        //Remove the bookmark from the local array
        bookmarks.remove(at: indexPath.row)
        
        //Reload the table view to reflect the changes
        bookmarkTableView.reloadData()
    }
}
