//
//  ReverseGeocode.swift
//  Sbs_Demo
//
//  Created by Ali on 19/02/22.
//

import Foundation
import CoreData

// MARK: - CoreData Model ReverseGeocode

public class ReverseGeocode : NSManagedObject {
    
    // MARK: - CoreData Model ReverseGeocode Fetch Request
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReverseGeocode> {
        return NSFetchRequest<ReverseGeocode>(entityName: "ReverseGeocode")
    }
    
    // MARK: - Properties
    
    @NSManaged public var address: String
    @NSManaged public var id: String
    
}
