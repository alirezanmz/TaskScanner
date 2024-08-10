import Foundation
import CoreData


// Manages task data, including network fetching, Core Data storage, and providing filtered tasks for the UI.
@MainActor
class TaskViewModel: ObservableObject {
    
    // Singleton instances for network and Core Data operations.
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    
    // All tasks fetched from the network or Core Data.
    @Published var tasks: [Assignment] = []
    
    // Filtered tasks based on search criteria.
    @Published private(set) var filteredTasks: [Assignment] = []

    // Fetches tasks from the network; falls back to Core Data on failure.
    func fetchTasks() async {
        do {
            let token = try await networkManager.login()
            let tasks = try await networkManager.fetchTasks(token: token)
            self.tasks = tasks
            self.filteredTasks = tasks
            await saveTasksToCoreData(tasks: tasks)
        } catch {
            print("Network error, loading from Core Data: \(error)")
            await loadTasksFromCoreData()
        }
    }
    
    // Saves tasks to Core Data.
    private func saveTasksToCoreData(tasks: [Assignment]) async {
        let context = coreDataManager.context
        await context.perform {
            // Delete existing tasks.
            let fetchRequest = CDTask.fetchRequest()
            fetchRequest.includesPropertyValues = false
            do {
                let existingTasks = try context.fetch(fetchRequest)
                existingTasks.forEach(context.delete)
                try context.save()
            } catch {
                print("Failed to delete tasks: \(error)")
            }

            // Add new tasks to Core Data.
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
            
            // Save new tasks.
            do {
                try context.save()
            } catch {
                print("Failed to save tasks: \(error)")
            }
        }
    }

    // Loads tasks from Core Data.
    private func loadTasksFromCoreData() async {
        let context = coreDataManager.context
        await context.perform { [weak self] in
            guard let self = self else { return }
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
                print("Failed to load tasks: \(error)")
            }
        }
    }
    
    // Provides a stream of filtered tasks.
    var filteredTasksStream: AsyncStream<[Assignment]> {
        AsyncStream { [weak self] continuation in
            guard let self = self else {
                continuation.finish()
                return
            }

            let cancellable = self.$filteredTasks
                .sink { tasks in
                    continuation.yield(tasks)
                }

            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }

    // Filters tasks based on search text.
    func filterTasks(searchText: String) {
        filteredTasks = searchText.isEmpty ? tasks : tasks.filter { task in
            task.title.contains(searchText) || task.details.contains(searchText)
        }
    }
}
