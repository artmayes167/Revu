//
//  Review+CoreDataProperties.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var date: Date?
    @NSManaged public var stars: Int32
    @NSManaged public var text: String?

}
