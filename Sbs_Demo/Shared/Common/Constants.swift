//
//  Constants.swift
//  Sbs_Demo
//
//  Created by Ali on 15/02/22.
//

import Foundation

// MARK: - App level Constants

struct Constants {
    static var filterMin : Float = 1.0
    static var filterMax : Float = 70000.0
    static var dateFormat = "yyyy-MM-dd"
    static var minimumStartDate = "506-01-01"
    static var radiusText = "Radius (KM) = "
    static var mapViewClusteringId = "MapItem"
    static var defaultFont = "HelveticaNeue"
}

// MARK: - Constant Strings

struct Messages {
    static var defaultTitle = "Alert"
    static var enableLocationMessage = "Please Enable Location Services in order to use app"
    static var enableLocationOk = "OK"
    static var serviceResponseFailedMessage = "Failed to get response from service"
    static var failedToGetFromDB = "Failed to get data from DB"
    static var failedToReverseGeocode = "Unable to Reverse Geocode Location"
    static var noMatchingAddress = "No Matching Addresses Found"
}

// MARK: - SEGUE Ids

enum SegueIdentifiers : String {
    case filter = "SegueFilter"
    case meteoriteDetail = "MeteoriteToMeteoriteDetail"
}


// MARK: - Enums

enum MassRange : String {
    case small = "0-5K"
    case medium = "5K-50K"
    case large = "50K Above"
}
