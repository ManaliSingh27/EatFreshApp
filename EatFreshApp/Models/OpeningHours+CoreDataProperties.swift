//
//  OpeningHours+CoreDataProperties.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 16/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData


extension OpeningHours {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OpeningHours> {
        return NSFetchRequest<OpeningHours>(entityName: "OpeningHours")
    }

    @NSManaged public var openNow: Bool
    @NSManaged public var eatery: Eatery?

}
