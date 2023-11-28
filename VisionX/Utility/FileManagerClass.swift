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
    
    func saveImage(photo: Photo, completion: @escaping (String?) -> Void) {
        // Extract the photo ID as a string
        let photoID = String(photo.id)

        // Checks if the URL is valid
        guard let url = URL(string: photo.src.original) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        // Creates a data task using URLSession to fetch data from the given URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Checks if there is valid data and no error
            if let data = data, error == nil, let uiImage = UIImage(data: data) {
                // folder name and file name based on photo ID
                let folderName = "SearchedImages"
                let fileName = "\(photoID).jpg"
                let relativePath = "\(folderName)/\(fileName)"

                // Checks if the image data can be compressed to JPEG format
                guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
                    completion(nil)
                    return
                }

                // Get the documents directory URL
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent(relativePath)

                // Create the necessary directory structure if it doesn't exist
                do {
                    try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)

                    // Write the image data to the file at the specified URL
                    try imageData.write(to: fileURL)
                    completion(relativePath)
                } catch {
                    // Print an error message if any issues occur during the image-saving process
                    print("Error saving image:", error.localizedDescription)
                    completion(nil)
                }
            } else if let error = error {
                // Print an error message if there is an issue with the data task
                print("Error downloading image: \(error)")
                completion(nil)
            }
        }
        // Resume the data task to initiate the download
        task.resume()
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
