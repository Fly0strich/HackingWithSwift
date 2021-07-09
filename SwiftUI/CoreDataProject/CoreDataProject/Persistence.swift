//
//  Persistence.swift
//  CoreDataProject
//
//  Created by Shae Willes on 6/10/21.
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
        container = NSPersistentContainer(name: "CoreDataProject")
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
