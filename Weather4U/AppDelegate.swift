//
//  AppDelegate.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UserDefaults를 사용하여 앱이 처음 실행되는지 확인
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "isAppAlreadyLaunchedOnce") == false {
            // 앱이 처음 실행되는 경우
            print("App launched first time")
            userDefaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            userDefaults.synchronize()
            
            // Core Data에 초기 데이터 저장
            saveInitialData()
        } else {
            // 앱이 이미 실행된 경우
            print("App already launched")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather4U")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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

extension AppDelegate {
    func saveInitialData() {
        let context = persistentContainer.viewContext
        
        // 예시로 Person 엔티티에 이름을 저장하는 코드
        let entity = NSEntityDescription.entity(forEntityName: "LocationAllData", in: context)!
        let newLocation = NSManagedObject(entity: entity, insertInto: context)
        newLocation.setValue("서울특별시", forKey: "region")
        newLocation.setValue("서울특별시", forKey: "city")
        newLocation.setValue("", forKey: "town")
        newLocation.setValue("", forKey: "village")
        newLocation.setValue(60, forKey: "x")
        newLocation.setValue(127, forKey: "y")
        newLocation.setValue(109, forKey: "sentence")
        newLocation.setValue("11B00000", forKey: "status")
        newLocation.setValue("11B10101", forKey: "temperature")
        
        do {
            try context.save()
            print("saveInitial Success")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
