//
//  MapItem.swift
//  Sbs_Demo
//
//  Created by Ali on 16/02/22.
//

import Foundation
import MapKit

// MARK: - Class MapItem

final class MapItem: NSObject, MKAnnotation {
    
    // MARK: - Properties
    let title: String?
    let address: String?
    let itemType: ItemType
    let coordinate: CLLocationCoordinate2D
    let date : Date
    var image: UIImage { return itemType.image }
    var id : String
    enum ItemType: UInt32 {
        case yellow = 0
        case green = 1
        case red = 2
        
        var image: UIImage {
            switch self {
            case .yellow:
                return #imageLiteral(resourceName: "yellow")
            case.green:
                return #imageLiteral(resourceName: "green")
            case .red:
                return #imageLiteral(resourceName: "red")
            }
        }
    }
    // MARK: - Initializer
    init(
        title: String?,
        date: Date,
        coordinate: CLLocationCoordinate2D,
        itemType : ItemType,
        id : String,
        address: String? = nil
    ) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
        self.itemType = itemType
        self.date = date
        self.id = id
        super.init()
    }
}
