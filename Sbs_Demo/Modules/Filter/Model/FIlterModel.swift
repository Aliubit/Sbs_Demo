//
//  FIlterModel.swift
//  Sbs_Demo
//
//  Created by Ali on 18/02/22.
//

import Foundation

// MARK: - Struct Filter Model
struct FilterModel {

    // MARK: - Properties
    
    var radius : Double?
    var startDate : Date?
    var endDate : Date?
    
    // MARK: - Helper Functions
    
    func isNil() -> Bool{
        return radius == nil && startDate == nil && endDate == nil
    }
    
    func hasDates() -> Bool {
        return startDate != nil || endDate != nil
    }
    
    func hasRadius() -> Bool {
        return radius != nil
    }
}
