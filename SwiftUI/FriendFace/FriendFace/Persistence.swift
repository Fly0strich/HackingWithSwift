//
//  Persistence.swift
//  FriendFace
//
//  Created by Shae Willes on 6/17/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        return result
    }()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FriendFace")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
