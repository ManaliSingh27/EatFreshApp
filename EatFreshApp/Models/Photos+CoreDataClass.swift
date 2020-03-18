//
//  Photos+CoreDataClass.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photos)
public class Photos: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case photoRef = "photo_reference"
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Photos", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        height = try container.decode(Int64.self, forKey: .height)
        width = try container.decode(Int64.self, forKey: .width)
        photoRef = try container.decode(String.self, forKey: .photoRef)

    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(photoRef, forKey: .photoRef)

    }
}
