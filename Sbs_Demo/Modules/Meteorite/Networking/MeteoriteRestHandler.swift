//
//  MeteoriteRest.swift
//  Sbs_Demo
//
//  Created by Ali on 15/02/22.
//

import Foundation
import Alamofire

// MARK: - Endpoints
// All the endpoints to be used in this module will be here
enum Endpoints : String {
    case getMeteorite = "https://data.nasa.gov/resource/y77d-th95.json"
}

// MARK: - Meteorite Rest Services Wrapper

class MeteoriteRestHandler {
    
    // Get call
    func getMeteoriteHistoricalData(completion : @escaping (AFDataResponse<Data?>) -> Void) {
        let urlString = Endpoints.getMeteorite.rawValue
        AF.request(urlString,method: .get).response { response in
            completion(response)
        }
    }
}

