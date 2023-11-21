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
    
    func saveImageToFileManager(_ uiImage: UIImage, folderName: String, fileName: String) -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        //UUID for Event and photo
        let relativeURL  = "\(folderName)/\(fileName)"
        
        do {
            // Get the documents directory URL
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(relativeURL)
            
            // Create the necessary directory structure if it doesn't exist
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            
            // Write the image data to the file at the specified URL
            try imageData.write(to: fileURL)
            print("Image Location: \(fileURL)")
            return relativeURL
            
        } catch {
            // Print an error message if any issues occur during the image-saving process
            print("Error saving image:", error.localizedDescription)
            return nil
        }
    }
    
    func loadImageFromFileManager(relativePath: String) -> UIImage {
        // Construct the local file URL by appending the relative path to the documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = documentsDirectory.appendingPathComponent(relativePath)
        
        do {
            // Read image data from the local file
            let imageData = try Data(contentsOf: localFileURL)
            if let uiImage = UIImage(data: imageData) {
                return uiImage
            } else {
                print("Failed to create UIImage from data")
                return UIImage(systemName: "person") ?? UIImage()
            }
        } catch {
            print("Error loading image:", error.localizedDescription)
            return UIImage(systemName: "person") ?? UIImage()
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
