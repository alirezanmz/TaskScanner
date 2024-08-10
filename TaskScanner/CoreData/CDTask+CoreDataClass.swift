//
//  CDTask+CoreDataClass.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation
import CoreData

@objc(CDTask)
// Core Data entity class for tasks, conforming to Codable for JSON encoding/decoding.
public class CDTask: NSManagedObject, Codable {
    
    // Maps JSON keys to Core Data properties.
    enum CodingKeys: String, CodingKey {
        case task
        case title
        case details = "description"  // Maps "description" in JSON to "details" in Core Data.
        case sort
        case wageType
        case businessUnitKey
        case businessUnit
        case parentTaskID
        case preplanningBoardQuickSelect
        case colorCode
        case workingTime
        case isAvailableInTimeTrackingKioskMode
    }
    
    // Decoder initializer to create a CDTask object from JSON.
    public required convenience init(from decoder: Decoder) throws {
        // Ensure the context and entity are available for decoding.
        guard let context = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "CDTask", in: managedObjectContext) else {
            fatalError("Failed to decode CDTask")
        }
        
        // Initialize the Core Data entity.
        self.init(entity: entity, insertInto: managedObjectContext)
        
        // Decode JSON into Core Data properties.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.task = try container.decode(String.self, forKey: .task)
        self.title = try container.decode(String.self, forKey: .title)
        self.details = try container.decode(String.self, forKey: .details)
        self.sort = try container.decode(String.self, forKey: .sort)
        self.wageType = try container.decode(String.self, forKey: .wageType)
        self.businessUnitKey = try container.decode(String.self, forKey: .businessUnitKey)
        self.businessUnit = try container.decode(String.self, forKey: .businessUnit)
        self.parentTaskID = try container.decode(String.self, forKey: .parentTaskID)
        self.preplanningBoardQuickSelect = try container.decodeIfPresent(String.self, forKey: .preplanningBoardQuickSelect)
        self.colorCode = try container.decode(String.self, forKey: .colorCode)
        self.workingTime = try container.decodeIfPresent(String.self, forKey: .workingTime)
        self.isAvailableInTimeTrackingKioskMode = try container.decode(Bool.self, forKey: .isAvailableInTimeTrackingKioskMode)
    }
    
    // Encodes a CDTask object to JSON.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(task, forKey: .task)
        try container.encode(title, forKey: .title)
        try container.encode(details, forKey: .details)
        try container.encode(sort, forKey: .sort)
        try container.encode(wageType, forKey: .wageType)
        try container.encode(businessUnitKey, forKey: .businessUnitKey)
        try container.encode(businessUnit, forKey: .businessUnit)
        try container.encode(parentTaskID, forKey: .parentTaskID)
        try container.encode(preplanningBoardQuickSelect, forKey: .preplanningBoardQuickSelect)
        try container.encode(colorCode, forKey: .colorCode)
        try container.encode(workingTime, forKey: .workingTime)
        try container.encode(isAvailableInTimeTrackingKioskMode, forKey: .isAvailableInTimeTrackingKioskMode)
    }
}
