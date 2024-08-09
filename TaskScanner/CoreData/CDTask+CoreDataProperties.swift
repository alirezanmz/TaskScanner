//
//  CDTask+CoreDataProperties.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation
import CoreData

extension CDTask {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTask> {
        return NSFetchRequest<CDTask>(entityName: "CDTask")
    }

    @NSManaged public var task: String
    @NSManaged public var title: String
    @NSManaged public var details: String
    @NSManaged public var sort: String
    @NSManaged public var wageType: String
    @NSManaged public var businessUnitKey: String
    @NSManaged public var businessUnit: String
    @NSManaged public var parentTaskID: String
    @NSManaged public var preplanningBoardQuickSelect: String?
    @NSManaged public var colorCode: String
    @NSManaged public var workingTime: String?
    @NSManaged public var isAvailableInTimeTrackingKioskMode: Bool
}
