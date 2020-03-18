//
//  Eatery+CoreDataClass.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 16/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey
{
    static let context = CodingUserInfoKey(rawValue: "context")
}

@objc(Eatery)
public class Eatery: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case iconUrl = "icon"
        case rating
        case userRatingTotal = "user_ratings_total"
        case vicinity
        case placeId = "place_id"
        case openHrs = "opening_hours"
        case photos = "photos"
        case eateryTypes = "types"

    }
    
    
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Eatery", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        rating = try container.decode(Double.self, forKey: .rating)
        userRatingTotal =   try container.decode(Int64.self, forKey: .userRatingTotal)
        vicinity =   try container.decode(String.self, forKey: .vicinity)
        placeId =   try container.decode(String.self, forKey: .placeId)
        eateryTypes = try container.decode([String].self, forKey: .eateryTypes)
        photos =   try container.decode(Set<Photos>.self, forKey: .photos) as NSSet
      //  openHrs =   try container.decode(OpeningHours.self, forKey: .openHrs)


    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(iconUrl, forKey: .iconUrl)
        try container.encode(rating, forKey: .rating)
        try container.encode(userRatingTotal, forKey: .userRatingTotal)
        try container.encode(vicinity, forKey: .vicinity)
        try container.encode(placeId, forKey: .placeId)

        try container.encode(openHrs, forKey: .openHrs)

    }
}

struct Results : Codable {
    let results: [Eatery]
}





