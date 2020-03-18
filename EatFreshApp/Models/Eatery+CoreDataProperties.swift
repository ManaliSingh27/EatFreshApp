//
//  Eatery+CoreDataProperties.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 18/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData


extension Eatery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Eatery> {
        return NSFetchRequest<Eatery>(entityName: "Eatery")
    }

    @NSManaged public var iconUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var userRatingTotal: Int64
    @NSManaged public var vicinity: String?
    @NSManaged public var placeId: String?
    @NSManaged public var eateryTypes: [String]?
    @NSManaged public var openHrs: OpeningHours?
    @NSManaged public var photos: NSSet?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for photos
extension Eatery {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photos)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photos)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

// MARK: Generated accessors for reviews
extension Eatery {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
