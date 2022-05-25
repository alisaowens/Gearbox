import UIKit
import CloudKit
import MobileCoreServices
import Foundation
import CoreData

class MainMenu: UIViewController {
    
    let container = CKContainer.default()
    var privateDatabase: CKDatabase?
    var recordZone: CKRecordZone?
    var zoneID: CKRecordZoneID?
    var gearID: CKRecordID?
    
    @IBOutlet weak var calculatorButton: UIBarButtonItem!
    
    var newGear: [NSManagedObject]?
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelButton(_ sender: Any) {
        if stackView.isHidden == true {
            UIView.animate(withDuration: 0.1){
                self.stackView.isHidden = false
            }
            cancelButton.setImage(UIImage(named: "CancelGray"), for: .normal)
        }
        else {
            UIView.animate(withDuration: 0.1){
                self.stackView.isHidden = true
            }
            cancelButton.setImage(UIImage(named: "Hamburger"), for: .normal)
        }
    }

    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    let privateSubscriptionId = "private-changes"
    
    let emptyArray = [String]()
    
    private let serverChangeTokenKey = "ServerChangeToken"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
 //       calculatorButton.image = UIImage(named: "Calculator")
  //      UserDefaults.standard.setValue(emptyArray, forKey: "idsToUpload")
        navigationController?.isToolbarHidden = true
        
   //     cleanGear()
   //     loadGear()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        uploadIdsToCloud()
        uploadEditedIdsToCloud()
        deleteIdsFromCloud()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        privateDatabase = container.privateCloudDatabase
        recordZone = CKRecordZone(zoneName: "GearZone")
        zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        
        let createZoneGroup = DispatchGroup()
        
        let userdefaults = UserDefaults.standard
        if userdefaults.object(forKey: "createdCustomZone") == nil {
            createZoneGroup.enter()
            let customZone = CKRecordZone(zoneID: zoneID!)
            let createZoneOperation = CKModifyRecordZonesOperation(recordZonesToSave: [customZone], recordZoneIDsToDelete: [])
            createZoneOperation.modifyRecordZonesCompletionBlock = { (saved, deleted, error) in
                if (error == nil) {
                    userdefaults.set("true", forKey: "createdCustomZone")
                    userdefaults.synchronize()
                    print("Created custom zone")
                }
                else {
                    if let ckerror = error as? CKError {
                        print("Error creating custom zone: \(ckerror.localizedDescription)")}
                    else {
                        print("Error creating custom zone, unable to find error code")
                    }
                }
                createZoneGroup.leave()
            }
            createZoneOperation.qualityOfService = .utility
            self.privateDatabase?.add(createZoneOperation)
        }
        else {
            print("Already created custom zone")
        }
        
        if userdefaults.object(forKey: "subscribedToChanges") == nil {
            let createSubscriptionOperation = self.createDatabaseSubscriptionOperation(subscriptionID: privateSubscriptionId)
            createSubscriptionOperation.modifySubscriptionsCompletionBlock = { (subscriptions, deletedIds, error) in
                if error == nil {
                    userdefaults.set("true", forKey: "subscribedToChanges")
                    userdefaults.synchronize()
                }
            }
            self.privateDatabase?.add(createSubscriptionOperation)
            print("Subscribed to changes")
        }
        else { print("Already subscribed to changes")}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    @IBAction func unwindFromTable(sender: UIStoryboardSegue){
        return
    }
    
    func createDatabaseSubscriptionOperation(subscriptionID: String) -> CKModifySubscriptionsOperation {
        let subscription = CKDatabaseSubscription.init(subscriptionID: subscriptionID)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
        operation.qualityOfService = .utility
        return operation
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
            print("Record added/changed in cloud and added to local cache: \(String(describing: record.value(forKey: "details")))")
        }
        operation.recordWithIDWasDeletedBlock = { (recordID, _) in
            self.deleteRecordFromLocalCache(recordID: recordID)
            print("Record deleted in cloud and deleted from local cache")
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
                print("Error fetching zone")
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
                print("Error fetching zone changes")
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
        let photoData = record.value(forKey: "photo")  as? Data
        let gearID = record.value(forKey: "gearID") as? String
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        } catch {
            let nserror = error as NSError
            print("Error adding gear to local cache: \(nserror), \(nserror.userInfo)")
        }
        print("Added new gear to local cache: \(String(describing: details))")
    }
    
    func deleteRecordFromLocalCache(recordID: CKRecordID) {
        var gears = [NSManagedObject]()
        var gear: NSManagedObject?
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let gearID = recordID.recordName
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        fetchRequest.predicate = NSPredicate(format: "gearID == %@", gearID)
        do {
            gears = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch CoreData gear after deletion. \(error), \(error.userInfo)")
        }
        guard !gears.isEmpty else {
            print("No gear found to match id deleted in ")
            return
        }
        gear = gears[0]
            managedContext.delete(gear!)
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
    
    func loadGear() {
        let pred = NSPredicate(format: "majorCategory != %@", "Water")
        let query = CKQuery(recordType: "Gear", predicate: pred)
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["details", "selfWeight", "manufWeight", "notes", "majorCategory", "category", "isStatic", "isHalf", "isTwin", "isSingle", "selfLength", "manufLength",  "gearID"]
        operation.recordFetchedBlock = { record in
            self.addRecordToLocalCache(record: record)
        }
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    print ("Fetched gears")
                } else {
                    print("Error fetching gear from cloud")
                }
            }
        }
        self.privateDatabase?.add(operation)
    }
    
    func cleanGear() {
        var gear: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        fetchRequest.predicate = NSPredicate(format: "gearID != nil")
        do {
            gear = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch CoreData gear. \(error), \(error.userInfo)")
        }
        print ("Fetched \(gear.count) gears")
        for selectedGear in gear {
            managedContext.delete(selectedGear)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
