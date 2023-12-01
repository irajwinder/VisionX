//
//  DataManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/21/23.
//

import UIKit
import CoreData

//Singleton Class
class DataManager: NSObject {
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    // Save Bookmark to CoreData
    func saveBookmark(imageURL: String, videoURL: String?) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a newBookMark Object
        let newBookmark = Bookmark(context: managedContext)
        
        // Set the values for attribute of the Bookmark entity
        newBookmark.imageURL = imageURL
        newBookmark.videoURL = videoURL
        
        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchBookmark() -> [Bookmark] {
        /// Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            // Fetch the bookmarks based on the fetch request
            return try managedContext.fetch(Bookmark.fetchRequest())
        } catch let error as NSError {
            // Handle the error
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    //Delete function for deleting entities
    func deleteEntity(_ entity: NSManagedObject) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(entity)
        
        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("\(entity.entity.name ?? "Entity") deleted successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

let datamanagerInstance = DataManager.sharedInstance
