//
//  MeteoriteDataHandler.swift
//  Sbs_Demo
//
//  Created by Ali on 18/02/22.
//

import Foundation
import CoreData

// MARK: - Protocol MeteoriteRepository

protocol MeteoriteRepository {
    
    func getAll() -> [MeteoriteDataModel]?
    func getFilteredDates(model : FilterModel) -> [MeteoriteDataModel]?
    func deleteAll()
}

// MARK: - Struct MeteoriteDataRepository

struct MeteoriteDataRepository : MeteoriteRepository {
    
    // MARK: - Functions
    
    func getAll() -> [MeteoriteDataModel]? {
        do {
           let result = try PersistanceStorage.shared.context.fetch(MeteoriteDataModel.fetchRequest())
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
    
    func getFilteredDates(model: FilterModel) -> [MeteoriteDataModel]? {
        let fetchRequest = NSFetchRequest<MeteoriteDataModel>(entityName: "MeteoriteDataModel")
        var predicate : NSPredicate!
        if let startDate = model.startDate, let endDate = model.endDate {
            predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
        }
        else if let startDate = model.startDate {
            predicate = NSPredicate(format: "(date >= %@)", startDate as CVarArg)
        }
        else if let endDate = model.endDate {
            predicate = NSPredicate(format: "(date <= %@)", endDate as CVarArg)
        }
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try PersistanceStorage.shared.context.fetch(fetchRequest)

            guard result.count > 0 else {return nil}

            return result

        } catch let error {
            debugPrint(error)
        }
        return nil
    }
    
    func deleteAll() {
        // Specify a batch to delete with a fetch request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "MeteoriteDataModel")

        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

        deleteRequest.resultType = .resultTypeObjectIDs

        let context = PersistanceStorage.shared.context

        do {
            let batchDelete = try context.execute(deleteRequest)
                as? NSBatchDeleteResult

            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
                else { return }

            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            )
            
        } catch let error {
            print("ERROR DELETING \(error)")
        }

    }
    
}
