//
//  AppDelegate.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData


let KMaster = "MyAudio.m4a"
let KUpdate = "New.m4a"
let Kcombined = "Combined.m4a"
let KFolder = "Myaudios"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var managedObjectContext: NSManagedObjectContext?
    var managedObjectModel: NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var appId: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let dataClass = DataClass.instance
        dataClass.AppId = "IOS 20141224"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        _ = DirectoryManager.instance.addSkipBackupAttributeToItemAtURL(url: URL.init(fileURLWithPath: documentsDirectory))
        
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

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "eword")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if (getManagedObjectContext() != nil) {
            if (managedObjectContext!.hasChanges) {
                do {
                    try managedObjectContext!.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext? {
        if (managedObjectContext != nil) {
            return managedObjectContext!
        }
        
        let coordinator = getPersistentStoreCoordinator()
        if (coordinator != nil) {
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext!.persistentStoreCoordinator = coordinator
        }
        return managedObjectContext
    }
    
    func getManagedObjectModel() -> NSManagedObjectModel {
        if (managedObjectModel != nil) {
            return managedObjectModel!
        }
        
        let modelURL = Bundle.main.url(forResource: "eword", withExtension: "momd")
        managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
        return managedObjectModel!
    }
    
    func getPersistentStoreCoordinator() -> NSPersistentStoreCoordinator? {
        if (persistentStoreCoordinator != nil) {
            return persistentStoreCoordinator!
        }
        
        let storeURL = applicationDocumentsDirectory().appendingPathComponent("eword.sqlite")
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: getManagedObjectModel())
        do {
            try persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        }
        catch {
            print(error)
            abort()
        }
        
        return persistentStoreCoordinator
    }

    func applicationDocumentsDirectory() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        _ = DirectoryManager.instance.addSkipBackupAttributeToItemAtURL(url: url!)
        return url!
    }
}

