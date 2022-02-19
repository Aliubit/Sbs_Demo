//
//  MeteoriteManager.swift
//  Sbs_Demo
//
//  Created by Ali on 18/02/22.
//

import Foundation
import UIKit
import CoreLocation

// MARK: - protocol MeteoriteManagerDelegate

protocol MeteoriteManagerDelegate : NSObjectProtocol {
    func didReceiveData(dataSource : [MapItem])
    func failToGetDataWithError(error : String)
    func failToGetLocation(error : String)
}

// MARK: - Class MeteoriteManager

class MeteoriteManager : NSObject {
    
    // MARK: - Properties
    
    weak var delegate : MeteoriteManagerDelegate?
    var locationManager : LocationManager!
    
    // MARK: - Helper Functions
    
    func setDelegate(delegate : MeteoriteManagerDelegate?) {
        self.delegate = delegate
        self.locationManager = LocationManager(delegate: self)
        self.locationManager.startTracking()
    }
    
    func getMeteoriteDataFromServer() {
        MeteoriteRestHandler().getMeteoriteHistoricalData(completion: {(response) in
            guard let data = response.data else {
                self.delegate?.failToGetDataWithError(error: Messages.serviceResponseFailedMessage)
                return
            }
            do {
                MeteoriteDataRepository().deleteAll()
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = PersistanceStorage.shared.context
                let response = try decoder.decode([MeteoriteDataModel].self, from: data)
                self.delegate?.didReceiveData(dataSource: response.map {$0.transformToMapItemModel()})
                try PersistanceStorage.shared.context.save()
            } catch _ {
            }
        })
    }
    
    func getMeteoriteDataFromLocalDB(model : FilterModel) {
        if model.isNil() {
            if let meteoriteData = MeteoriteDataRepository().getAll(), meteoriteData.count > 0 {
                self.delegate?.didReceiveData(dataSource: meteoriteData.map({$0.transformToMapItemModel()}))
            }
            else {
                self.delegate?.failToGetDataWithError(error: Messages.failedToGetFromDB)
            }
        }
        else {
            // FILTER
            guard var result = MeteoriteDataRepository().getFilteredDates(model: model) else {return}
            result = result.filter({(item) in
                let destination = CLLocation(latitude: item.reclat, longitude: item.reclong)
                let distance = self.locationManager.location.distance(from: destination)
                return distance.isLessThanOrEqualTo(model.radius! * 1000) // conversion to KM
            })
            self.delegate?.didReceiveData(dataSource: result.map({$0.transformToMapItemModel()}))
        }
    }
}

// MARK: - LocationManagerDelegate Implementation

extension MeteoriteManager : LocationManagerDelegate {
    func didGetLocation() {}
    func failToGetLocation() {
        self.delegate?.failToGetLocation(error: Messages.enableLocationMessage)
    }
}
