//
//  AppDelegate.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import CoreData
import Swinject
import SwinjectStoryboard
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public var container: Container = {
        let container = Container()
        
        // Data
        container.register(UserDefaults.self) { _ in
            print("User Defaults")
            return UserDefaults()
        }
        container.register(PreferencesHelper.self) { resolver in
            print("Preferences Helper initialized")
            return PreferencesHelper(userDefaults: resolver.resolve(UserDefaults.self)!)
        }
        container.register(DatabaseHelper.self) { _ in
            print("Database Helper initialized")
            return DatabaseHelper()
        }
        container.register(DataManager.self) { resolver in
            print("Data Manager initialized")
            return DataManager.init(
                databaseHelper: resolver.resolve(DatabaseHelper.self)!,
                preferencesHelper: resolver.resolve(PreferencesHelper.self)!)
        }
        
        // Presenters
        container.register(PlayersEditorPresenter.self) { resolver in
            print("Players Editor Presenter")
            return PlayersEditorPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        container.register(OnboardingPresenter.self) { resolver in
            print("Onboarding Presenter")
            return OnboardingPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        container.register(DashboardPresenter.self) { resolver in
            print("Dashboard Presenter")
            return DashboardPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        // View
        container.storyboardInitCompleted(PlayersEditorViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(PlayersEditorPresenter.self)!
        }
        
        container.storyboardInitCompleted(OnboardingViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(OnboardingPresenter.self)!
        }
        
        container.storyboardInitCompleted(DashboardViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(DashboardPresenter.self)!
        }
        
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MagicalRecord.setupCoreDataStack()
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        window?.rootViewController = storyboard.instantiateInitialViewController()
    
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Munchkin_Level_Counter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

