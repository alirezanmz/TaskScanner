//
//  Task.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation

struct Assignment: Codable {
    let task: String
    let title: String
    let details: String
    let sort: String
    let wageType: String
    let businessUnitKey: String?
    let businessUnit: String
    let parentTaskID: String
    let preplanningBoardQuickSelect: String?
    let colorCode: String
    let workingTime: String?
    let isAvailableInTimeTrackingKioskMode: Bool
    
    enum CodingKeys: String, CodingKey {
        case task
        case title
        case details = "description"
        case sort
        case wageType
        case businessUnitKey = "BusinessUnitKey"
        case businessUnit
        case parentTaskID
        case preplanningBoardQuickSelect
        case colorCode
        case workingTime
        case isAvailableInTimeTrackingKioskMode
    }
    // Existing custom initializer for Codable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.task = try container.decode(String.self, forKey: .task)
        self.title = try container.decode(String.self, forKey: .title) 
        self.details = try container.decodeIfPresent(String.self, forKey: .details) ?? "No description available"
        self.sort = try container.decode(String.self, forKey: .sort)
        self.wageType = try container.decode(String.self, forKey: .wageType)
        self.businessUnitKey = try container.decodeIfPresent(String.self, forKey: .businessUnitKey) ?? "Unknown Business Unit"
        self.businessUnit = try container.decode(String.self, forKey: .businessUnit)
        self.parentTaskID = try container.decodeIfPresent(String.self, forKey: .parentTaskID) ?? ""
        self.preplanningBoardQuickSelect = try container.decodeIfPresent(String.self, forKey: .preplanningBoardQuickSelect)
        self.colorCode = try container.decode(String.self, forKey: .colorCode)
        self.workingTime = try container.decodeIfPresent(String.self, forKey: .workingTime)
        self.isAvailableInTimeTrackingKioskMode = try container.decode(Bool.self, forKey: .isAvailableInTimeTrackingKioskMode)
    }
    
    // New initializer for Core Data usage
    init(
        task: String,
        title: String,
        details: String,
        sort: String,
        wageType: String,
        businessUnitKey: String?,
        businessUnit: String,
        parentTaskID: String,
        preplanningBoardQuickSelect: String?,
        colorCode: String,
        workingTime: String?,
        isAvailableInTimeTrackingKioskMode: Bool
    ) {
        self.task = task
        self.title = title
        self.details = details
        self.sort = sort
        self.wageType = wageType
        self.businessUnitKey = businessUnitKey
        self.businessUnit = businessUnit
        self.parentTaskID = parentTaskID
        self.preplanningBoardQuickSelect = preplanningBoardQuickSelect
        self.colorCode = colorCode
        self.workingTime = workingTime
        self.isAvailableInTimeTrackingKioskMode = isAvailableInTimeTrackingKioskMode
    }
}
