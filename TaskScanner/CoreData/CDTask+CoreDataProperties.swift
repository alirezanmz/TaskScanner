//
//  CDTask+CoreDataProperties.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation
import CoreData

// Extension to define Core Data properties and a fetch request for the CDTask entity.
extension CDTask {
    
    // Provides a fetch request for retrieving CDTask objects from Core Data.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTask> {
        return NSFetchRequest<CDTask>(entityName: "CDTask")
    }

    // Core Data attributes for the CDTask entity.
    @NSManaged public var task: String
    @NSManaged public var title: String
    @NSManaged public var details: String
    @NSManaged public var sort: String
    @NSManaged public var wageType: String
    @NSManaged public var businessUnitKey: String
    @NSManaged public var businessUnit: String
    @NSManaged public var parentTaskID: String
    @NSManaged public var preplanningBoardQuickSelect: String?  // Optional property.
    @NSManaged public var colorCode: String
    @NSManaged public var workingTime: String?  // Optional property.
    @NSManaged public var isAvailableInTimeTrackingKioskMode: Bool
}
