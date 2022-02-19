//
//  MeteoriteDetailRepository.swift
//  Sbs_Demo
//
//  Created by Ali on 19/02/22.
//

import Foundation
import CoreData
import CoreLocation

// MARK: - Protocol MeteoriteDetailRepositoryProtocol

protocol MeteoriteDetailRepositoryProtocol {
    func getAll() -> [ReverseGeocode]?
    func getAddress(id : String) -> ReverseGeocode?
    func create(id : String, address : String)
}

// MARK: - Struct MeteoriteDetailRepository

struct MeteoriteDetailRepository : MeteoriteDetailRepositoryProtocol {
    func getAll() -> [ReverseGeocode]? {
        
        return nil
    }
    
    func getAddress(id : String) -> ReverseGeocode? {
        
        let fetchRequest = NSFetchRequest<ReverseGeocode>(entityName: "ReverseGeocode")
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistanceStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else {return nil}

            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }
    
    func create(id : String, address: String) {
        let reverseGeocode = ReverseGeocode(context: PersistanceStorage.shared.context)
        reverseGeocode.id = id
        reverseGeocode.address = address
        PersistanceStorage.shared.saveContext()
    }
}
