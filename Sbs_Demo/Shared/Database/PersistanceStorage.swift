//
//  PersistanceStorage.swift
//  Sbs_Demo
//
//  Created by Ali on 17/02/22.
//

import Foundation
import CoreData

final class PersistanceStorage {
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Variables
    
    static let shared = PersistanceStorage()
    lazy var context = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sbs_Demo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
