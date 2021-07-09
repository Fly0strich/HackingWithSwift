//
//  Friend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Shae Willes on 6/17/21.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var users: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? "N/A"
    }
    
    public var userArray: [User] {
        let set = users  as? Set<User> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for origin
extension Friend {

    @objc(addOriginObject:)
    @NSManaged public func addToOrigin(_ value: User)

    @objc(removeOriginObject:)
    @NSManaged public func removeFromOrigin(_ value: User)

    @objc(addOrigin:)
    @NSManaged public func addToOrigin(_ values: NSSet)

    @objc(removeOrigin:)
    @NSManaged public func removeFromOrigin(_ values: NSSet)

}

extension Friend : Identifiable {

}
