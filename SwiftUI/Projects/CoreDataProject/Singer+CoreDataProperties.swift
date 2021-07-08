//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Shae Willes on 6/10/21.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    
    var wrappedFirstName: String {
        firstName ?? "Unknown Name"
    }
    
    var wrappedLastName: String {
        lastName ?? "Unknown Name"
    }

}
