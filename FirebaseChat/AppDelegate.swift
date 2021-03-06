//
//  AppDelegate.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/16/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let chatViewController = AllChatsViewController()
        let context = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        chatViewController.context = context
        window?.makeKeyAndVisible()
        fakeDate(context: context)
         debugPrint("Documents Directory: \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)")
        window?.rootViewController = UINavigationController(
            rootViewController: chatViewController)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FirebaseChat")
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

    func fakeDate(context: NSManagedObjectContext) {
        let dataSeeded = UserDefaults.standard.bool(forKey: "dataSeeded")
        guard !dataSeeded else { return }

        let people = [("John","Nicholes"),("Matt","Parker")]
        for person in people {
            let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
            contact.firstName = person.0
            contact.lastName = person.1
        }
        do {
            try context.save()
        }catch {
            print("Error Saving: \(error)")
        }

        UserDefaults.standard.setValue(true, forKey: "dataSeeded")
    }

}

