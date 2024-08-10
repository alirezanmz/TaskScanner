//
//  AppDelegate.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/7/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?  // Main application window.
    let coreDataManager = CoreDataManager.shared  // Singleton instance of CoreDataManager.

    // Called when the application has finished launching. Sets up the initial view controller.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        window?.makeKeyAndVisible()
        return true
    }
    
    // Called when the application is about to terminate. Saves changes in the Core Data context.
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataManager.saveContext()
    }
}
