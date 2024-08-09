//
//  TaskViewModel.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation
import CoreData

@MainActor
class TaskViewModel: ObservableObject {
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    
    @Published var tasks: [Assignment] = []
    @Published private(set) var filteredTasks: [Assignment] = []

    func fetchTasks() async {
        do {
            let token = try await networkManager.login()
            let tasks = try await networkManager.fetchTasks(token: token)
            self.tasks = tasks
            self.filteredTasks = tasks
            await saveTasksToCoreData(tasks: tasks)
        } catch {
            print("Error fetching tasks from network, loading from Core Data: \(error)")
            await loadTasksFromCoreData()
        }
    }
    
    private func saveTasksToCoreData(tasks: [Assignment]) async {
        let context = coreDataManager.context
        await context.perform {
            // Step 1: Delete existing tasks from Core Data
            let fetchRequest = CDTask.fetchRequest()
            fetchRequest.includesPropertyValues = false // Optimize the fetch request
            do {
                let existingTasks = try context.fetch(fetchRequest)
                for task in existingTasks {
                    context.delete(task)
                }
                // Save context after deletion
                try context.save()
            } catch {
                print("Failed to delete existing tasks: \(error)")
            }

            // Step 2: Add new tasks to Core Data
            tasks.forEach { task in
                let cdTask = CDTask(context: context)
                cdTask.task = task.task
                cdTask.title = task.title
                cdTask.details = task.details
                cdTask.sort = task.sort
                cdTask.wageType = task.wageType
                cdTask.businessUnitKey = task.businessUnitKey ?? ""
                cdTask.businessUnit = task.businessUnit
                cdTask.parentTaskID = task.parentTaskID
                cdTask.preplanningBoardQuickSelect = task.preplanningBoardQuickSelect
                cdTask.colorCode = task.colorCode
                cdTask.workingTime = task.workingTime
                cdTask.isAvailableInTimeTrackingKioskMode = task.isAvailableInTimeTrackingKioskMode
            }
            
            // Step 3: Save the new tasks
            do {
                try context.save()
            } catch {
                print("Failed to save new tasks to Core Data: \(error)")
            }
        }
    }

    
      // Load tasks from Core Data
      private func loadTasksFromCoreData() async {
          let context = coreDataManager.context
          await context.perform {
              let fetchRequest = CDTask.fetchRequest()
              do {
                  let cdTasks = try context.fetch(fetchRequest)
                  self.tasks = cdTasks.map { cdTask in
                      Assignment(
                        task: cdTask.task,
                        title: cdTask.title,
                        details: cdTask.details,
                        sort: cdTask.sort,
                        wageType: cdTask.wageType,
                        businessUnitKey: cdTask.businessUnitKey,
                        businessUnit: cdTask.businessUnit,
                        parentTaskID: cdTask.parentTaskID,
                        preplanningBoardQuickSelect: cdTask.preplanningBoardQuickSelect,
                        colorCode: cdTask.colorCode,
                        workingTime: cdTask.workingTime,
                        isAvailableInTimeTrackingKioskMode: cdTask.isAvailableInTimeTrackingKioskMode
                      )
                  }
                  self.filteredTasks = self.tasks
              } catch {
                  print("Failed to load tasks from Core Data: \(error)")
              }
          }
      }
    
    
    var filteredTasksStream: AsyncStream<[Assignment]> {
        AsyncStream { continuation in
            let cancellable = $filteredTasks
                .sink { tasks in
                    continuation.yield(tasks)
                }

            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }

    func filterTasks(searchText: String) {
        if searchText.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { task in
                task.title.contains(searchText) || task.details.contains(searchText)
            }
        }
    }
}
