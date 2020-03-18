//
//  Review+CoreDataProperties.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 18/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var authorName: String?
    @NSManaged public var profilePicUrl: String?
    @NSManaged public var rating: Double
    @NSManaged public var text: String?
    @NSManaged public var eatery: Eatery?

}
