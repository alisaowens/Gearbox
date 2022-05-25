import UIKit
import CloudKit
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let container = CKContainer.default()
    var privateDatabase: CKDatabase?
    var recordZone: CKRecordZone?
    var zoneID: CKRecordZoneID?
    var gearID: CKRecordID?
    
    let privateSubscriptionId = "private-changes"
    
    private let serverChangeTokenKey = "ServerChangeToken"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        DispatchQueue.main.async {
            print("Received notification, but not taking action")
        }
/*
        privateDatabase = container.privateCloudDatabase
        recordZone = CKRecordZone(zoneName: "GearZone")
        zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        self.fetchZoneChanges(database: privateDatabase!, databaseTokenKey: "private", zoneIDs: [zoneID!]) {}
*/
        completionHandler(.newData)
 
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
        privateDatabase = container.privateCloudDatabase
        recordZone = CKRecordZone(zoneName: "GearZone")
        zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        self.fetchZoneChanges(database: privateDatabase!, databaseTokenKey: "private", zoneIDs: [zoneID!]) {}
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GearBox")
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
    
    func fetchZoneChanges(database: CKDatabase, databaseTokenKey: String, zoneIDs: [CKRecordZoneID], completion: @escaping () -> Void) {
        
        var changeToken: CKServerChangeToken? = nil
        let changeTokenData = UserDefaults.standard.data(forKey: serverChangeTokenKey)
        if changeTokenData != nil {
            changeToken = NSKeyedUnarchiver.unarchiveObject(with: changeTokenData!) as! CKServerChangeToken?
        }
        
        var optionsByRecordZoneID = [CKRecordZoneID: CKFetchRecordZoneChangesOptions]()
        for zoneID in zoneIDs {
            let options = CKFetchRecordZoneChangesOptions()
            options.previousServerChangeToken =  changeToken
            optionsByRecordZoneID[zoneID] = options
        }
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: zoneIDs, optionsByRecordZoneID: optionsByRecordZoneID)
        operation.recordChangedBlock = { (record) in
            self.addRecordToLocalCache(record: record)
            print("Record added/changed in cloud: \(String(describing: record.value(forKey: "details")))")
        }
        operation.recordWithIDWasDeletedBlock = { (recordID, _) in
            self.deleteRecordFromLocalCache(recordID: recordID)
            print("Record deleted in cloud")
        }
        operation.recordZoneChangeTokensUpdatedBlock = { (zoneID, changeToken, data) in
            guard let changeToken = changeToken else {
                print("Error updating record zone change token")
                return}
            let changeTokenData = NSKeyedArchiver.archivedData(withRootObject: changeToken)
            UserDefaults.standard.set(changeTokenData, forKey: self.serverChangeTokenKey)
        }
        operation.recordZoneFetchCompletionBlock = { (zoneID, changeToken, data, more, error) in
            guard error == nil else {
                print("Error fetching zone, \(String(describing: error?.localizedDescription))")
                return
            }
            guard let changeToken = changeToken else {
                print("No change token found")
                return
            }
            let changeTokenData = NSKeyedArchiver.archivedData(withRootObject: changeToken)
            UserDefaults.standard.set(changeTokenData, forKey: self.serverChangeTokenKey)
        }
        operation.fetchRecordZoneChangesCompletionBlock = { (error) in
            guard error == nil else {
                print("Error fetching zone changes, \(String(describing: error?.localizedDescription))")
                return
            }
        }
        database.add(operation)
    }

    func addRecordToLocalCache(record: CKRecord) {
        let details = record.value(forKey: "details") as? String
        let category = record.value(forKey: "category") as? String
        let majorCategory = record.value(forKey: "majorCategory") as? String
        let isSingle = record.value(forKey: "isSingle") as? Bool
        let isHalf = record.value(forKey: "isHalf") as? Bool
        let isTwin = record.value(forKey: "isTwin") as? Bool
        let isStatic = record.value(forKey: "isStatic") as? Bool
        let selfLength = record.value(forKey: "selfLength") as? String
        let selfWeight = record.value(forKey: "selfWeight") as? String
        let manufLength = record.value(forKey: "manufLength") as? String
        let manufWeight = record.value(forKey: "manufWeight") as? String
        let calculatedDensity = record.value(forKey: "calculatedDensity") as? String
        let manufDensity = record.value(forKey: "manufDensity") as? String
        let size = record.value(forKey: "size") as? String
        let notes = record.value(forKey: "notes") as? String
        let update = record.value(forKey: "update") as? NSDate
        var photoData: Data?
        if let photo = record.value(forKey: "photo") as? CKAsset {
            do {
                let data = try Data(contentsOf: photo.fileURL)
                photoData = data
            } catch {
                print(error.localizedDescription)
            }
        }
        let gearID = record.value(forKey: "gearID") as? String
        var gears = [NSManagedObject]()
        persistentContainer.performBackgroundTask { (managedContext) in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
            guard gearID != nil else {
                print("gearID is nil")
                return
            }
            fetchRequest.predicate = NSPredicate(format: "gearID == %@", gearID!)
            do {
                gears = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch gear. \(error), \(error.userInfo)")
            }
            if !gears.isEmpty {
                print("Gear already saved to cache, attempting to edit")
                let gear = gears[0]
                gear.setValue(details, forKeyPath: "details")
                gear.setValue(category, forKeyPath: "category")
                gear.setValue(majorCategory, forKeyPath: "majorCategory")
                gear.setValue(isSingle, forKeyPath: "isSingle")
                gear.setValue(isHalf, forKeyPath: "isHalf")
                gear.setValue(isTwin, forKeyPath: "isTwin")
                gear.setValue(isStatic, forKeyPath: "isStatic")
                gear.setValue(selfLength, forKeyPath: "selfLength")
                gear.setValue(selfWeight, forKeyPath: "selfWeight")
                gear.setValue(manufLength, forKeyPath: "manufLength")
                gear.setValue(manufWeight, forKeyPath: "manufWeight")
                gear.setValue(calculatedDensity, forKeyPath: "calculatedDensity")
                gear.setValue(manufDensity, forKeyPath: "manufDensity")
                gear.setValue(size, forKeyPath: "size")
                gear.setValue(notes, forKeyPath: "notes")
                gear.setValue(update, forKeyPath: "update")
                gear.setValue(photoData, forKeyPath: "photo")
                gear.setValue(gearID, forKeyPath: "gearID")
                do {
                    try managedContext.save()
                    print("Added new gear to local cache: \(String(describing: details))")
                } catch {
                    let nserror = error as NSError
                    print("Error adding gear to local cache: \(nserror), \(nserror.userInfo)")
                }
            }
            else {
                let entity = NSEntityDescription.entity(forEntityName: "Gear", in: managedContext)!
                let gear = NSManagedObject(entity: entity, insertInto: managedContext)
                gear.setValue(details, forKeyPath: "details")
                gear.setValue(category, forKeyPath: "category")
                gear.setValue(majorCategory, forKeyPath: "majorCategory")
                gear.setValue(isSingle, forKeyPath: "isSingle")
                gear.setValue(isHalf, forKeyPath: "isHalf")
                gear.setValue(isTwin, forKeyPath: "isTwin")
                gear.setValue(isStatic, forKeyPath: "isStatic")
                gear.setValue(selfLength, forKeyPath: "selfLength")
                gear.setValue(selfWeight, forKeyPath: "selfWeight")
                gear.setValue(manufLength, forKeyPath: "manufLength")
                gear.setValue(manufWeight, forKeyPath: "manufWeight")
                gear.setValue(calculatedDensity, forKeyPath: "calculatedDensity")
                gear.setValue(manufDensity, forKeyPath: "manufDensity")
                gear.setValue(size, forKeyPath: "size")
                gear.setValue(notes, forKeyPath: "notes")
                gear.setValue(update, forKeyPath: "update")
                gear.setValue(photoData, forKeyPath: "photo")
                gear.setValue(gearID, forKeyPath: "gearID")
                do {
                    try managedContext.save()
                    print("Added new gear to local cache: \(String(describing: details))")
                } catch {
                    let nserror = error as NSError
                    print("Error adding gear to local cache: \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func deleteRecordFromLocalCache(recordID: CKRecordID) {
        var gears = [NSManagedObject]()
        var gear: NSManagedObject?
        persistentContainer.performBackgroundTask { (managedContext) in
            let gearID = recordID.recordName
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
            fetchRequest.predicate = NSPredicate(format: "gearID == %@", gearID)
            do {
                gears = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch CoreData gear after deletion. \(error), \(error.userInfo)")
            }
            guard !gears.isEmpty else {
                print("No gear found to match id deleted in cloud")
                return
            }
            gear = gears[0]
            managedContext.delete(gear!)
            do {
                try managedContext.save()
                print("Deleted gear from local cache")
            } catch {
                let nserror = error as NSError
                print("Error deleting gear from local cache: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addRecordToDownloadQueue(id: String) {
        let userdefaults = UserDefaults.standard
        var queuedRecordsToDownload = [String]()
        if userdefaults.object(forKey: "recordsToDownload") != nil {
            queuedRecordsToDownload = (userdefaults.object(forKey: "recordsToDownload") as! NSArray) as! [String]
        }
        queuedRecordsToDownload.append(id)
        print("Added id to queue to download containing \(queuedRecordsToDownload.count) ids")
        userdefaults.set(queuedRecordsToDownload, forKey: "recordsToDownload")
        userdefaults.synchronize()
    }
    
    func addRecordToDownloadEditQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedRecordsToDownloadEdit = [String]()
        if userdefaults.object(forKey: "recordsToDownloadEdit") != nil {
            queuedRecordsToDownloadEdit = (userdefaults.object(forKey: "recordsToDownloadEdit") as! NSArray) as! [String]
        }
        queuedRecordsToDownloadEdit.append(id)
        print("Added id to queue to download edit containing \(queuedRecordsToDownloadEdit.count) ids")
        userdefaults.set(queuedRecordsToDownloadEdit, forKey: "recordsToDownloadEdit")
        userdefaults.synchronize()
    }
    
    func addRecordToDownloadDeleteQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToDownloadDelete = [String]()
        if userdefaults.object(forKey: "recordsToDownloadDelete") != nil {
            queuedIdsToDownloadDelete = (userdefaults.object(forKey: "recordsToDownloadDelete") as! NSArray) as! [String]
        }
        queuedIdsToDownloadDelete.append(id)
        print("Added id to queue to download delete containing \(queuedIdsToDownloadDelete.count) ids")
        userdefaults.set(queuedIdsToDownloadDelete, forKey: "recordsToDownloadDelete")
        userdefaults.synchronize()
    }
    
    func removeRecordFromDownloadQueue(id: String) {
        let userdefaults = UserDefaults.standard
        var queuedRecordsToDownload = [String]()
        if userdefaults.object(forKey: "recordsToDownload") != nil {
            queuedRecordsToDownload = (userdefaults.object(forKey: "recordsToDownload") as! NSArray) as! [String]
        }
        queuedRecordsToDownload = queuedRecordsToDownload.filter{$0 != id}
        print("Removed id from queue to download containing \(queuedRecordsToDownload.count) ids")
        userdefaults.set(queuedRecordsToDownload, forKey: "recordsToDownload")
        userdefaults.synchronize()
    }
    
    func removeRecordFromDownloadEditQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedRecordsToDownloadEdit = [String]()
        if userdefaults.object(forKey: "recordsToDownloadEdit") != nil {
            queuedRecordsToDownloadEdit = (userdefaults.object(forKey: "recordsToDownloadEdit") as! NSArray) as! [String]
        }
        queuedRecordsToDownloadEdit = queuedRecordsToDownloadEdit.filter{$0 != id}
        print("Removed id from queue to download edit containing \(queuedRecordsToDownloadEdit.count) ids")
        userdefaults.set(queuedRecordsToDownloadEdit, forKey: "recordsToDownloadEdit")
        userdefaults.synchronize()
    }
    
    func removeRecordFromDownloadDeleteQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToDownloadDelete = [String]()
        if userdefaults.object(forKey: "recordsToDownloadDelete") != nil {
            queuedIdsToDownloadDelete = (userdefaults.object(forKey: "recordsToDownloadDelete") as! NSArray) as! [String]
        }
        queuedIdsToDownloadDelete = queuedIdsToDownloadDelete.filter{$0 != id}
        print("Removed id from queue to download delete containing \(queuedIdsToDownloadDelete.count) ids")
        userdefaults.set(queuedIdsToDownloadDelete, forKey: "recordsToDownloadDelete")
        userdefaults.synchronize()
    }
    
}
