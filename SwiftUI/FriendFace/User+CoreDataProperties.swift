//
//  User+CoreDataProperties.swift
//  FriendFace
//
//  Created by Shae Willes on 6/19/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var registered: Date?
    @NSManaged public var friends: NSSet?
    @NSManaged public var tags: NSSet?

    public var wrappedAbout: String {
        about ?? "N/A"
    }

    public var wrappedAddress: String {
        address ?? "N/A"
    }

    public var wrappedCompany: String {
        company ?? "N/A"
    }

    public var wrappedEmail: String {
        email ?? "N/A"
    }

    public var wrappedId: UUID {
        id ?? UUID()
    }

    public var wrappedName: String {
        name ?? "N/A"
    }

    public var wrappedRegistered: Date {
        registered ?? Date()
    }

    public var friendArray: [Friend] {
        let set = friends as? Set<Friend> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

    public var tagArray: [String] {
        let set = tags as? Set<String> ?? []
        return set.sorted()
    }

}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User : Identifiable {

}
