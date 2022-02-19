//
//  LocationManager.swift
//  Sbs_Demo
//
//  Created by Ali on 16/02/22.
//

import Foundation
import CoreLocation

class LocationManager : NSObject {
    
    // MARK: - Constructor
    
    init(delegate : LocationManagerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - Variables
    
    private var locationManager = CLLocationManager()
    var location : CLLocation = CLLocation(latitude: 52.3676, longitude: 4.9041) // default Amsterdem
    weak var delegate : LocationManagerDelegate?
    
    // MARK: - User location request and tracking
    func startTracking() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        //self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.distanceFilter = 500
        self.locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            break
        case .denied,.restricted:
            self.delegate?.failToGetLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0, let location = locations.last else {return }
        
        self.location = location
        self.delegate?.didGetLocation()
    }
}

// MARK: - LocationManagerDelegate functions

protocol LocationManagerDelegate : NSObjectProtocol {
    func didGetLocation()
    func failToGetLocation()
}

