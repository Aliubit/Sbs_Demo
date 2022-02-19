//
//  MeteoriteDataModel+CoreDataClass.swift
//  
//
//  Created by Ali on 18/02/22.
//
//

import Foundation
import CoreData
import CoreLocation

// MARK: - Class MeteoriteDataModel
// This class is implementation of both NSManagedObject and Codable

@objc(MeteoriteDataModel)
public class MeteoriteDataModel: NSManagedObject, Codable {

    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case name, id, nametype, recclass, mass, fall, year, reclat, reclong, geolocation
        case computedRegionCbhkFwbd = ":@computed_region_cbhk_fwbd"
        case computedRegionNnqa25F4 = ":@computed_region_nnqa_25f4"
    }
    
    // MARK: - Functions
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(name, forKey: .name)
            try container.encode(id, forKey: .id)
            try container.encode(nametype, forKey: .nametype)
            try container.encode(recclass, forKey: .recclass)
            try container.encode(mass, forKey: .mass)
            try container.encode(fall, forKey: .fall)
            try container.encode(date, forKey: .year)
            try container.encode(reclat, forKey: .reclat)
            try container.encode(reclong, forKey: .reclong)
            //try container.encode(geolocation, forKey: .geolocation)
            try container.encode(computedRegionCbhkFwbd, forKey: .computedRegionCbhkFwbd)
            try container.encode(computedRegionNnqa25F4, forKey: .computedRegionNnqa25F4)
        } catch {
            print("ERROR IN ENCODING")
        }
        
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "MeteoriteDataModel", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
            id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
            nametype = try values.decodeIfPresent(String.self, forKey: .nametype) ?? ""
            recclass = try values.decodeIfPresent(String.self, forKey: .recclass) ?? ""
            mass = try values.decodeIfPresent(String.self, forKey: .mass) ?? ""
            fall = try values.decodeIfPresent(String.self, forKey: .fall) ?? ""
            date = try (values.decodeIfPresent(String.self, forKey: .year))?.toDate() ?? Date()
            reclat = try Double(values.decodeIfPresent(String.self, forKey: .reclat) ?? "") ?? 0.0
            reclong = try Double(values.decodeIfPresent(String.self, forKey: .reclong) ?? "") ?? 0.0
            //geolocation = try values.decodeIfPresent(Geolocation.self, forKey: .name)
            computedRegionCbhkFwbd = try values.decodeIfPresent(String.self, forKey: .computedRegionCbhkFwbd) ?? ""
            computedRegionNnqa25F4 = try values.decodeIfPresent(String.self, forKey: .computedRegionNnqa25F4) ?? ""
        }
        catch {
            print("ERROR IN DECODING")
        }
        
    }
    
}

// MARK: - Extension for CoreData

extension MeteoriteDataModel {
    // MARK: - Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeteoriteDataModel> {
        return NSFetchRequest<MeteoriteDataModel>(entityName: "MeteoriteDataModel")
    }

    // MARK: - Properties
    
    @NSManaged public var computedRegionCbhkFwbd: String?
    @NSManaged public var computedRegionNnqa25F4: String?
    @NSManaged public var date: Date?
    @NSManaged public var fall: String?
    @NSManaged public var id: String?
    @NSManaged public var mass: String?
    @NSManaged public var name: String?
    @NSManaged public var nametype: String?
    @NSManaged public var recclass: String?
    @NSManaged public var reclat: Double
    @NSManaged public var reclong: Double

    // MARK: - Function
    // This function is responsible for converting datamodel to mapitem viewmodel
    func transformToMapItemModel() -> MapItem {
        let mass = Double(self.mass ?? "0.0") ?? 0.0
        var itemType = MapItem.ItemType.yellow
        if mass >= 0.0 && mass <= 5000.0 {
            itemType = .yellow
        }
        else if mass >= 5000.0 && mass <= 50000.0 {
            itemType = .green
        }
        else {
            itemType = .red
        }
        return MapItem(title: self.name, date: self.date ?? Date(), coordinate: CLLocationCoordinate2D(latitude: reclat, longitude: reclong), itemType: itemType, id : self.id! ,address: nil)
    }
    
}


/*
// MARK: - Geolocation
struct Geolocation: Codable {
    let type: String?
    let coordinates: [Double]
}
*/
/*
 enum Fall: String, Codable {
     case fell = "Fell"
     case found = "Found"
 }
 */
