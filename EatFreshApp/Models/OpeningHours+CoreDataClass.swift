//
//  OpeningHours+CoreDataClass.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 16/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData

@objc(OpeningHours)
public class OpeningHours: NSManagedObject , Codable{
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "OpeningHours", in: managedObjectContext) else {
                fatalError("Failed to decode OpeningHours")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        openNow = try container.decode(Bool.self, forKey: .openNow)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(openNow, forKey: .openNow)
    }
}
