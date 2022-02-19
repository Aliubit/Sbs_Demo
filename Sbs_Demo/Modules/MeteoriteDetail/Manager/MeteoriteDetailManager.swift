//
//  MeteoriteDetailManager.swift
//  Sbs_Demo
//
//  Created by Ali on 19/02/22.
//

import Foundation
import CoreLocation

// MARK: - Protocol MeteoriteDetailManagerDelegate

protocol MeteoriteDetailManagerDelegate : NSObjectProtocol {
    
}

// MARK: - Class MeteoriteDetailManager

class MeteoriteDetailManager : NSObject{
    
    // MARK: - Variables
    
    weak var delegate : MeteoriteDetailManagerDelegate?
    
    // MARK: - Initializer
    
    init(delegate : MeteoriteDetailManagerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - Helper Functions
    
    func getAddressfromCoordinates(lat : Double, lon : Double, id : String, completion : @escaping (String?,String?) -> Void) {
        
        if let reverseGeocode = MeteoriteDetailRepository().getAddress(id : id) {
            print("Fetching Reverse address from LOCAL DB")
            completion(reverseGeocode.address,nil)
        }
        else {
            print("Fetching Reverse address from Core Location")
            let location = CLLocation(latitude: lat, longitude: lon)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                // Process Response
                if error != nil {
                    completion(nil,Messages.failedToReverseGeocode)
                }
                else {
                    if let placemarks = placemarks, let placemark = placemarks.first, let compactAddress = placemark.compactAddress {
                        MeteoriteDetailRepository().create(id : id, address: compactAddress)
                        completion(compactAddress,nil)
                    } else {
                        completion(nil,Messages.noMatchingAddress)
                    }
                }
            }
        }
    }
}
