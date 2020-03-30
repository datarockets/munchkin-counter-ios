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
//import Fabric
//import Crashlytics

enum Storyboard: String {
    case Main
    case Onboarding
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public var container: Container = {
        let container = Container()
        
        // MARK: Data
        
        container.register(UserDefaults.self) { _ in
            return UserDefaults()
        }
        
        container.register(PreferencesHelper.self) { resolver in
            loggingPrint("Preferences Helper initialized")
            return PreferencesHelper(userDefaults: resolver.resolve(UserDefaults.self)!)
        }
        
        container.register(DatabaseHelper.self) { _ in
            loggingPrint("Database Helper initialized")
            return DatabaseHelper()
        }
        
        container.register(DataManager.self) { resolver in
            loggingPrint("Data Manager initialized")
            return DataManager.init(
                databaseHelper: resolver.resolve(DatabaseHelper.self)!,
                preferencesHelper: resolver.resolve(PreferencesHelper.self)!)
        }.inObjectScope(.container)
        
        // MARK: Presenters
        
        container.register(PlayersEditorPresenter.self) { resolver in
            loggingPrint("Players Editor Presenter")
            return PlayersEditorPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        container.register(OnboardingPresenter.self) { resolver in
            loggingPrint("Onboarding Presenter")
            return OnboardingPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        container.register(DashboardPresenter.self) { resolver in
            loggingPrint("Dashboard Presenter")
            return DashboardPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        container.register(PlayerPresenter.self) { resolver in
            loggingPrint("Player Presenter")
            return PlayerPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        container.register(GameResultPresenter.self) { resolver in
            loggingPrint("Game Result Presenter")
            return GameResultPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        container.register(ChartsPresenter.self) { resolver in
            loggingPrint("Charts Presenter")
            return ChartsPresenter.init(dataManager: resolver.resolve(DataManager.self)!)
        }
        
        // MARK: View
        
        container.register(OnboardingViewController.self) { resolver in
            let controller = OnboardingViewController()
            controller.presenter = resolver.resolve(OnboardingPresenter.self)!
            return controller
        }
        
        container.storyboardInitCompleted(PlayersEditorViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(PlayersEditorPresenter.self)!
        }
        
        container.storyboardInitCompleted(DashboardViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(DashboardPresenter.self)!
        }
        
        container.storyboardInitCompleted(PlayerViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(PlayerPresenter.self)!
        }
        
        container.storyboardInitCompleted(GameResultViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(GameResultPresenter.self)!
        }
        
        container.storyboardInitCompleted(ChartsViewController.self) { resolver, controller in
            controller.presenter = resolver.resolve(ChartsPresenter.self)!
        }
        
        return container
    }()
    
//    func initFabric() {
//        let resourceURL: URL = Bundle.main.url(forResource: "fabric.apikey", withExtension: nil)!
//        let fabricAPIKey: String?
//        do {
//            fabricAPIKey = try String(contentsOf: resourceURL, encoding: String.Encoding.utf8)
//        } catch _ {
//            fabricAPIKey = nil
//        }
//        let whitespaceToTrim: CharacterSet = CharacterSet.whitespacesAndNewlines
//        let fabricAPIKeyTrimmed: String = fabricAPIKey!.trimmingCharacters(in: whitespaceToTrim )
//        loggingPrint("Key for Fabric: \(fabricAPIKeyTrimmed)")
//        Crashlytics.start(withAPIKey: fabricAPIKeyTrimmed)
//        Fabric.with([Crashlytics.self])
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        initFabric()
        Appearance.setupUIAppearance()
        MagicalRecord.setupCoreDataStack()
        checkOnboarding()
        return true
    }
    
    func checkOnboarding() {
        let preferencesHelper = container.resolve(PreferencesHelper.self)
        if (preferencesHelper?.userSeenOnboarding)! {
            launchStoryboard(storyboard: .Main)
        } else {
            launchStoryboard(storyboard: .Onboarding)
        }
        
    }
    
    func launchStoryboard(storyboard: Storyboard) {
        switch storyboard {
            case .Main:
                let storyboard = SwinjectStoryboard.create(name: storyboard.rawValue, bundle: nil, container: container)
                let rootViewController = storyboard.instantiateInitialViewController()! as UIViewController
                let navigationController = UINavigationController(rootViewController: rootViewController)
                window?.rootViewController = navigationController
                break
            case .Onboarding:
                window?.rootViewController = container.resolve(OnboardingViewController.self)
                break
        }

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
        container.loadPersistentStores(completionHandler: { (_, error) in
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
