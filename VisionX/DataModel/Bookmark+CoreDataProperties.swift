//
//  Bookmark+CoreDataProperties.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/20/23.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var bookmarkURL: String?

}

extension Bookmark : Identifiable {

}
