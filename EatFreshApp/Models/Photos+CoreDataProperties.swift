//
//  Photos+CoreDataProperties.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var photoRef: String?
    @NSManaged public var eatery: Eatery?

}
