//
//  Review+CoreDataClass.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 18/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Review)
public class Review: NSManagedObject , Codable {

   
    
    enum CodingKeys: String, CodingKey {
          case authorName = "author_name"
          case profilePicUrl = "profile_photo_url"
          case rating = "rating"
        case text
        case placeId = "place_id"
        
      }
      
      // MARK: - Decodable
      required convenience public init(from decoder: Decoder) throws {
          guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Review", in: managedObjectContext) else {
                  fatalError("Failed to decode User")
          }
          self.init(entity: entity, insertInto: managedObjectContext)
          let container = try decoder.container(keyedBy: CodingKeys.self)
          authorName = try container.decode(String.self, forKey: .authorName)
          profilePicUrl = try container.decode(String.self, forKey: .profilePicUrl)
          rating = try container.decode(Double.self, forKey: .rating)
        text = try container.decode(String.self, forKey: .text)

      }
      
      // MARK: - Encodable
      public func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(authorName, forKey: .authorName)
          try container.encode(profilePicUrl, forKey: .profilePicUrl)
          try container.encode(rating, forKey: .rating)
        try container.encode(text, forKey: .text)


      }
}

struct ReviewResults : Codable {
    
    let result : Reviews
}

struct Reviews :Codable
{
    let reviews : [Review]
}
