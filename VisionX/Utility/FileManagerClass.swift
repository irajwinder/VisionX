//
//  FileManagerClass.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/21/23.
//

import Foundation
import SwiftUI

//Singleton Class
class FileManagerClass: NSObject {
    
    static let sharedInstance: FileManagerClass = {
        let instance = FileManagerClass()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    func saveImageToFileManager(imageData: Data, photo: Photo) -> String? {
        let photoID = String(photo.id)
        
        // folder name and file name based on photo ID
        let folderName = "BookmarkedImages"
        let fileName = "\(photoID).jpg"
        let relativeURL = "\(folderName)/\(fileName)"
        
        do {
            // Get the documents directory URL
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(relativeURL)
            
            // Create the necessary directory structure if it doesn't exist
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            
            // Write the image data to the file at the specified URL
            try imageData.write(to: fileURL)
            return relativeURL
        } catch {
            // Print an error message if any issues occur during the image-saving process
            print("Error saving image:", error.localizedDescription)
            return nil
        }
    }
    
    func saveVideoToFileManager(videoData: Data, video: Video) -> String? {
        let videoID = String(video.id)
        
        // folder name and file name based on Video ID
        let folderName = "BookmarkedVideos"
        let fileName = "\(videoID).mp4"
        let relativeURL = "\(folderName)/\(fileName)"
        
        do {
            // Get the documents directory URL
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(relativeURL)
            
            // Create the necessary directory structure if it doesn't exist
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            
            // Write the videoData to the file at the specified URL
            try videoData.write(to: fileURL)
            return relativeURL
        } catch {
            // Print an error message if any issues occur during the image-saving process
            print("Error saving image:", error.localizedDescription)
            return nil
        }
    }
    
    func loadImageDataFromFileManager(relativePath: String) -> Data? {
        // Construct the local file URL by appending the relative path to the documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = documentsDirectory.appendingPathComponent(relativePath)
        
        do {
            // Read image data from the local file
            let imageData = try Data(contentsOf: localFileURL)
            return imageData
        } catch {
            print("Error loading image data:", error.localizedDescription)
            return nil
        }
    }
    
    func loadURLFromFileManager(relativePath: String) -> URL? {
        // Construct the local file URL by appending the relative path to the documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = documentsDirectory.appendingPathComponent(relativePath)
        
        // Check if the file exists before returning the URL
        if FileManager.default.fileExists(atPath: localFileURL.path) {
            return localFileURL
        } else {
            return nil
        }
    }
    
    func deleteImageFromFileManager(relativePath: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = documentsDirectory.appendingPathComponent(relativePath)
        
        do {
            try FileManager.default.removeItem(at: localFileURL)
            print("Image deleted from file manager:", localFileURL)
        } catch {
            print("Error deleting image from file manager:", error.localizedDescription)
        }
    }
}

let fileManagerClassInstance = FileManagerClass.sharedInstance
