//
//  DataManager.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/21/23.
//

import UIKit

//Singleton Class
class DataManager: NSObject {
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }

    // Save user data to CoreData
    func bookmark(bookmarkURL: String) {
        // Obtains a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Accessing the managed context from the persistent container
        let managedContext = appDelegate.persistentContainer.viewContext

        //Create a newBookMark Object
        let newBookmark = Bookmark(context: managedContext)

        // Set the values for attribute of the Bookmark entity
        newBookmark.bookmarkURL = bookmarkURL
        
        do {
            // Attempting to save the changes made to the managed context
            try managedContext.save()
            print("Bookmark data saved successfully.")
        } catch let error as NSError {
            // Informs the user that an error occurred while saving the data.
            print("Could not save. \(error), \(error.userInfo)")
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
