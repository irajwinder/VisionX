//
//  Bookmark+CoreDataProperties.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/30/23.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var videoURL: String?

}

extension Bookmark : Identifiable {

}
