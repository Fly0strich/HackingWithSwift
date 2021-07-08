//
//  Friend+CoreDataClass.swift
//  FriendFace
//
//  Created by Shae Willes on 6/17/21.
//
//

import Foundation
import CoreData

@objc(Friend)
public class Friend: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, name
    }
    
    enum DecoderConfigurationError: Error {
        case missingManagedObjectContext
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
