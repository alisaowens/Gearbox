import UIKit
import CloudKit
import MobileCoreServices
import Foundation
import os.log
import CoreData

public extension UIViewController {
    
    func uploadIdsToCloud() {
        let userdefaults = UserDefaults.standard
        var idsToUploadToCloud = [String]()
        if userdefaults.object(forKey: "idsToUpload") != nil {
            idsToUploadToCloud = (userdefaults.object(forKey: "idsToUpload") as! NSArray) as! [String]
        }
        if idsToUploadToCloud.isEmpty {
            print("No records to upload to cloud")
            return
        }
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        var gears = [NSManagedObject]()
        var gear: NSManagedObject?
        
        for id in idsToUploadToCloud {
            fetchRequest.predicate = NSPredicate(format: "gearID == %@", id)
            do {
                gears = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch CoreData gear. \(error), \(error.userInfo)")
            }
            guard !gears.isEmpty else {
                print("No gear found to match id in idsToUpload")
                removeIdFromUploadQueue(id: id)
                continue
            }
            gear = gears[0]
            let details = gear?.value(forKeyPath: "details") as? String
            let category = gear?.value(forKeyPath: "category") as? String
            let majorCategory = gear?.value(forKeyPath: "majorCategory") as? String
            let isSingle = gear?.value(forKeyPath: "isSingle") as? Bool
            let isHalf = gear?.value(forKeyPath: "isHalf") as? Bool
            let isTwin = gear?.value(forKeyPath: "isTwin") as? Bool
            let isStatic = gear?.value(forKeyPath: "isStatic") as? Bool
            let selfLength = gear?.value(forKeyPath: "selfLength") as? String
            let selfWeight = gear?.value(forKeyPath: "selfWeight") as? String
            let manufLength = gear?.value(forKeyPath: "manufLength") as? String
            let manufWeight = gear?.value(forKeyPath: "manufWeight") as? String
            let calculatedDensity = gear?.value(forKeyPath: "calculatedDensity") as? String
            let manufDensity = gear?.value(forKeyPath: "manufDensity") as? String
            let size = gear?.value(forKeyPath: "size") as? String
            let notes = gear?.value(forKeyPath: "notes") as? String
            let update = gear?.value(forKeyPath: "update") as? NSDate
            let photoData = gear?.value(forKeyPath: "photo") as? Data
            guard gear?.value(forKeyPath: "gearID") != nil else {
                return
            }
            let gearID = gear?.value(forKeyPath: "gearID") as! String
            
            let recordID = CKRecordID(recordName: gearID, zoneID: zoneID)
            let newRecord = CKRecord(recordType: "Gear", recordID: recordID)
            
            var url: URL?
            if photoData != nil {
                url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
                do {
                    try photoData!.write(to: url!)
                } catch let e as NSError {
                    print("Error! \(e)");
                    return
                }
                let asset = CKAsset(fileURL: url!)
                newRecord.setObject(asset, forKey: "photo")
            }
            newRecord.setObject(details as CKRecordValue?, forKey: "details")
            newRecord.setObject(selfWeight as CKRecordValue?, forKey: "selfWeight")
            newRecord.setObject(manufWeight as CKRecordValue?, forKey: "manufWeight")
            newRecord.setObject(notes as CKRecordValue?, forKey: "notes")
            newRecord.setObject(category as CKRecordValue?, forKey: "category")
            newRecord.setObject(majorCategory as CKRecordValue?, forKey: "majorCategory")
            newRecord.setObject(size as CKRecordValue?, forKey: "size")
            newRecord.setObject(selfLength as CKRecordValue?, forKey: "selfLength")
            newRecord.setObject(manufLength as CKRecordValue?, forKey: "manufLength")
            newRecord.setObject(calculatedDensity as CKRecordValue?, forKey: "calculatedDensity")
            newRecord.setObject(manufDensity as CKRecordValue?, forKey: "manufDensity")
            newRecord.setObject(isSingle as CKRecordValue?, forKey: "isSingle")
            newRecord.setObject(isHalf as CKRecordValue?, forKey: "isHalf")
            newRecord.setObject(isTwin as CKRecordValue?, forKey: "isTwin")
            newRecord.setObject(isStatic as CKRecordValue?, forKey: "isStatic")
            newRecord.setObject(update as CKRecordValue?, forKey: "update")
            newRecord.setObject(gearID as CKRecordValue?, forKey: "gearID")
            
            let modifyRecordsOperation = CKModifyRecordsOperation( recordsToSave: [newRecord], recordIDsToDelete: nil)
            modifyRecordsOperation.timeoutIntervalForRequest = 10
            modifyRecordsOperation.timeoutIntervalForResource = 10
                    
            modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                if let error = error as? CKError {
                    print("Error uploading new record, adding id to queue: \(String(describing: details)) with \(idsToUploadToCloud.count - 1) others")
                    print ("Error code: \(error.localizedDescription)")
                }
                else {
                    print("Record uploaded to cloud: \(String(describing: details))")
                    self.removeIdFromUploadQueue(id: id)
                }
            }
            modifyRecordsOperation.qualityOfService = .userInitiated
            privateDatabase.add(modifyRecordsOperation)
        }
    }
    
    func uploadEditedIdsToCloud() {
        let userdefaults = UserDefaults.standard
        var idsToUploadToCloudEdit = [String]()
        if userdefaults.object(forKey: "idsToUploadEdit") != nil {
            idsToUploadToCloudEdit = (userdefaults.object(forKey: "idsToUploadEdit") as! NSArray) as! [String]
        }
        if idsToUploadToCloudEdit.isEmpty {
            print("No records to upload edit")
            return
        }
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        var gears = [NSManagedObject]()
        var gear: NSManagedObject?
            
        for id in idsToUploadToCloudEdit{
            fetchRequest.predicate = NSPredicate(format: "gearID == %@", id)
            do {
                gears = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch CoreData gear. \(error), \(error.userInfo)")
            }
            guard !gears.isEmpty else {
                print("No gear found to match id in idsToUploadEdit")
                removeIdFromUploadEditQueue(id: id)
                continue
            }
            gear = gears[0]
            let gearID = gear?.value(forKeyPath: "gearID") as! String
            let recordID = CKRecordID(recordName: gearID, zoneID: zoneID)
            
            let operation = CKFetchRecordsOperation(recordIDs: [recordID])
            operation.fetchRecordsCompletionBlock = {records, error in
                if let ckerror = error as? CKError {
                    if ckerror.code == .unknownItem || ckerror.code == .partialFailure {
                        print("Record not found, attempting to upload.")
                        self.uploadGearToCloud(gear: gear!)
                    }
                    else {
                    print ("Error uploading edited record, adding to queue to upload edit")
                    print ("Error code: \(ckerror.localizedDescription)")
                    }
                }
                else {
                    guard records != nil else {
                        return
                    }
                    let details = gear?.value(forKeyPath: "details") as? String
                    let category = gear?.value(forKeyPath: "category") as? String
                    let majorCategory = gear?.value(forKeyPath: "majorCategory") as? String
                    let isSingle = gear?.value(forKeyPath: "isSingle") as? Bool
                    let isHalf = gear?.value(forKeyPath: "isHalf") as? Bool
                    let isTwin = gear?.value(forKeyPath: "isTwin") as? Bool
                    let isStatic = gear?.value(forKeyPath: "isStatic") as? Bool
                    let selfLength = gear?.value(forKeyPath: "selfLength") as? String
                    let selfWeight = gear?.value(forKeyPath: "selfWeight") as? String
                    let manufLength = gear?.value(forKeyPath: "manufLength") as? String
                    let manufWeight = gear?.value(forKeyPath: "manufWeight") as? String
                    let calculatedDensity = gear?.value(forKeyPath: "calculatedDensity") as? String
                    let manufDensity = gear?.value(forKeyPath: "manufDensity") as? String
                    let size = gear?.value(forKeyPath: "size") as? String
                    let notes = gear?.value(forKeyPath: "notes") as? String
                    let update = gear?.value(forKeyPath: "update") as? NSDate
                    let photoData = gear?.value(forKeyPath: "photo") as? Data
                    let gearRecord = records![recordID]
                    
                    var url: URL?
                    if photoData != nil {
                        url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
                        do {
                            try photoData!.write(to: url!)
                        } catch let e as NSError {
                            print("Error! \(e)");
                            return
                        }
                        let asset = CKAsset(fileURL: url!)
                        gearRecord?.setObject(asset, forKey: "photo")
                    }
                    gearRecord?.setObject(details as CKRecordValue?, forKey: "details")
                    gearRecord?.setObject(selfWeight as CKRecordValue?, forKey: "selfWeight")
                    gearRecord?.setObject(manufWeight as CKRecordValue?, forKey: "manufWeight")
                    gearRecord?.setObject(notes as CKRecordValue?, forKey: "notes")
                    gearRecord?.setObject(category as CKRecordValue?, forKey: "category")
                    gearRecord?.setObject(majorCategory as CKRecordValue?, forKey: "majorCategory")
                    gearRecord?.setObject(size as CKRecordValue?, forKey: "size")
                    gearRecord?.setObject(selfLength as CKRecordValue?, forKey: "selfLength")
                    gearRecord?.setObject(manufLength as CKRecordValue?, forKey: "manufLength")
                    gearRecord?.setObject(calculatedDensity as CKRecordValue?, forKey: "calculatedDensity")
                    gearRecord?.setObject(manufDensity as CKRecordValue?, forKey: "manufDensity")
                    gearRecord?.setObject(isSingle as CKRecordValue?, forKey: "isSingle")
                    gearRecord?.setObject(isHalf as CKRecordValue?, forKey: "isHalf")
                    gearRecord?.setObject(isTwin as CKRecordValue?, forKey: "isTwin")
                    gearRecord?.setObject(isStatic as CKRecordValue?, forKey: "isStatic")
                    gearRecord?.setObject(update as CKRecordValue?, forKey: "update")
                    gearRecord?.setObject(gearID as CKRecordValue?, forKey: "gearID")

                    let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [gearRecord!], recordIDsToDelete: nil)
                    modifyRecordsOperation.timeoutIntervalForRequest = 10
                    modifyRecordsOperation.timeoutIntervalForResource = 10
                            
                    modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                        if let error = error as? CKError {
                            print("Error uploading edited record, adding to edit queue: \(String(describing: details))")
                            print ("Error code: \(error.localizedDescription)")
                        }
                       else {
                            print("Edited record uploaded to cloud: \(String(describing: details))")
                            self.removeIdFromUploadEditQueue(id: id)
                            self.removeIdFromUploadQueue(id: id)
                        }
                    }
                    modifyRecordsOperation.qualityOfService = .userInitiated
                    privateDatabase.add(modifyRecordsOperation)
                }
            }
        operation.qualityOfService = .userInitiated
        privateDatabase.add(operation)
        }
    }
    
    func deleteIdsFromCloud() {
        let userdefaults = UserDefaults.standard
        var idsToDeleteFromCloud = [String]()
        if userdefaults.object(forKey: "idsToDelete") != nil {
            idsToDeleteFromCloud = (userdefaults.object(forKey: "idsToDelete") as! NSArray) as! [String] }
        if idsToDeleteFromCloud.isEmpty {
            print("No records to delete from cloud")
            return
        }
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        for id in idsToDeleteFromCloud {
            let myID = CKRecordID(recordName: id, zoneID: zoneID)
            let operation = CKModifyRecordsOperation(recordsToSave: [], recordIDsToDelete: [myID])
            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let ckerror = error as? CKError {
                    if ckerror.code == .unknownItem || ckerror.code == .partialFailure {
                        print ("Record not found, removing from queue")
                        self.removeIdFromDeleteQueue(id: id)
                        self.removeIdFromUploadQueue(id: id)
                        self.removeIdFromUploadEditQueue(id: id)
                        }
                    else {
                        print ("Error deleting from cloud, adding to queue")
                        print ("Error code: \(ckerror.localizedDescription)")
                        }
                }
                else {
                    print("Deleted record in cloud")
                    self.removeIdFromDeleteQueue(id: id)
                    self.removeIdFromUploadQueue(id: id)
                    self.removeIdFromUploadEditQueue(id: id)
                    }
                }
            operation.qualityOfService = .userInitiated
            privateDatabase.add(operation)
        }
    }
    
    func addIdToUploadQueue(id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToUploadToCloud = [String]()
        if userdefaults.object(forKey: "idsToUpload") != nil {
            queuedIdsToUploadToCloud = (userdefaults.object(forKey: "idsToUpload") as! NSArray) as! [String]
        }
        queuedIdsToUploadToCloud.append(id)
        print("Added id to queue to upload containing \(queuedIdsToUploadToCloud.count) ids")
        userdefaults.set(queuedIdsToUploadToCloud, forKey: "idsToUpload")
        userdefaults.synchronize()
    }
    
    func addIdToUploadEditQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToUploadEditToCloud = [String]()
        if userdefaults.object(forKey: "idsToUploadEdit") != nil {
            queuedIdsToUploadEditToCloud = (userdefaults.object(forKey: "idsToUploadEdit") as! NSArray) as! [String]
        }
        queuedIdsToUploadEditToCloud.append(id)
        print("Added id to queue to upload edit containing \(queuedIdsToUploadEditToCloud.count) ids")
        userdefaults.set(queuedIdsToUploadEditToCloud, forKey: "idsToUploadEdit")
        userdefaults.synchronize()
    }
    
    func addIdToDeleteQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToDeleteFromCloud = [String]()
        if userdefaults.object(forKey: "idsToDelete") != nil {
            queuedIdsToDeleteFromCloud = (userdefaults.object(forKey: "idsToDelete") as! NSArray) as! [String]
        }
        queuedIdsToDeleteFromCloud.append(id)
        print("Added id to queue to delete containing \(queuedIdsToDeleteFromCloud.count) ids")
        userdefaults.set(queuedIdsToDeleteFromCloud, forKey: "idsToDelete")
        userdefaults.synchronize()
    }
    
    func removeIdFromUploadQueue(id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToUploadToCloud = [String]()
        if userdefaults.object(forKey: "idsToUpload") != nil {
            queuedIdsToUploadToCloud = (userdefaults.object(forKey: "idsToUpload") as! NSArray) as! [String]
        }
        queuedIdsToUploadToCloud = queuedIdsToUploadToCloud.filter{$0 != id}
        print("Removed id from queue to upload containing \(queuedIdsToUploadToCloud.count) ids")
        userdefaults.set(queuedIdsToUploadToCloud, forKey: "idsToUpload")
        userdefaults.synchronize()
    }
    
    func removeIdFromUploadEditQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToUploadEditToCloud = [String]()
        if userdefaults.object(forKey: "idsToUploadEdit") != nil {
            queuedIdsToUploadEditToCloud = (userdefaults.object(forKey: "idsToUploadEdit") as! NSArray) as! [String]
        }
        queuedIdsToUploadEditToCloud = queuedIdsToUploadEditToCloud.filter{$0 != id}
        print("Removed id from queue to upload edit containing \(queuedIdsToUploadEditToCloud.count) ids")
        userdefaults.set(queuedIdsToUploadEditToCloud, forKey: "idsToUploadEdit")
        userdefaults.synchronize()
    }
    
    func removeIdFromDeleteQueue (id: String) {
        let userdefaults = UserDefaults.standard
        var queuedIdsToDeleteFromCloud = [String]()
        if userdefaults.object(forKey: "idsToDelete") != nil {
            queuedIdsToDeleteFromCloud = (userdefaults.object(forKey: "idsToDelete") as! NSArray) as! [String]
        }
        queuedIdsToDeleteFromCloud = queuedIdsToDeleteFromCloud.filter{$0 != id}
        print("Removed id from queue to delete containing \(queuedIdsToDeleteFromCloud.count) ids")
        userdefaults.set(queuedIdsToDeleteFromCloud, forKey: "idsToDelete")
        userdefaults.synchronize()
    }
    
    internal func uploadGearToCloud(gear: NSManagedObject) {
        
        let details = gear.value(forKeyPath: "details") as? String
        let category = gear.value(forKeyPath: "category") as? String
        let majorCategory = gear.value(forKeyPath: "majorCategory") as? String
        let isSingle = gear.value(forKeyPath: "isSingle") as? Bool
        let isHalf = gear.value(forKeyPath: "isHalf") as? Bool
        let isTwin = gear.value(forKeyPath: "isTwin") as? Bool
        let isStatic = gear.value(forKeyPath: "isStatic") as? Bool
        let selfLength = gear.value(forKeyPath: "selfLength") as? String
        let selfWeight = gear.value(forKeyPath: "selfWeight") as? String
        let manufLength = gear.value(forKeyPath: "manufLength") as? String
        let manufWeight = gear.value(forKeyPath: "manufWeight") as? String
        let calculatedDensity = gear.value(forKeyPath: "calculatedDensity") as? String
        let manufDensity = gear.value(forKeyPath: "manufDensity") as? String
        let size = gear.value(forKeyPath: "size") as? String
        let notes = gear.value(forKeyPath: "notes") as? String
        let update = gear.value(forKeyPath: "update") as? NSDate
        let photoData = gear.value(forKeyPath: "photo") as? Data
        guard gear.value(forKeyPath: "gearID") != nil else {
            print("gearID is nil, cannot upload")
            return
        }
        let gearID = gear.value(forKeyPath: "gearID") as! String
        
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecordID(recordName: gearID, zoneID: zoneID)
        
        let newRecord = CKRecord(recordType: "Gear", recordID: recordID)
        
        var url: URL?
        if photoData != nil {
            url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
            do {
                try photoData!.write(to: url!)
            } catch let e as NSError {
                print("Error! \(e)");
                return
            }
            let asset = CKAsset(fileURL: url!)
            newRecord.setObject(asset, forKey: "photo")
        }
        newRecord.setObject(details as CKRecordValue?, forKey: "details")
        newRecord.setObject(selfWeight as CKRecordValue?, forKey: "selfWeight")
        newRecord.setObject(manufWeight as CKRecordValue?, forKey: "manufWeight")
        newRecord.setObject(notes as CKRecordValue?, forKey: "notes")
        newRecord.setObject(category as CKRecordValue?, forKey: "category")
        newRecord.setObject(majorCategory as CKRecordValue?, forKey: "majorCategory")
        newRecord.setObject(size as CKRecordValue?, forKey: "size")
        newRecord.setObject(selfLength as CKRecordValue?, forKey: "selfLength")
        newRecord.setObject(manufLength as CKRecordValue?, forKey: "manufLength")
        newRecord.setObject(calculatedDensity as CKRecordValue?, forKey: "calculatedDensity")
        newRecord.setObject(manufDensity as CKRecordValue?, forKey: "manufDensity")
        newRecord.setObject(isSingle as CKRecordValue?, forKey: "isSingle")
        newRecord.setObject(isHalf as CKRecordValue?, forKey: "isHalf")
        newRecord.setObject(isTwin as CKRecordValue?, forKey: "isTwin")
        newRecord.setObject(isStatic as CKRecordValue?, forKey: "isStatic")
        newRecord.setObject(update as CKRecordValue?, forKey: "update")
        newRecord.setObject(gearID as CKRecordValue?, forKey: "gearID")
        
        let modifyRecordsOperation = CKModifyRecordsOperation( recordsToSave: [newRecord], recordIDsToDelete: nil)
        modifyRecordsOperation.timeoutIntervalForRequest = 10
        modifyRecordsOperation.timeoutIntervalForResource = 10
        modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
            if let error = error as? CKError {
                print("Error uploading new record, adding id to queue: \(String(describing: details))")
                print ("Error code: \(error.localizedDescription)")
                self.addIdToUploadQueue(id: gearID)
            }
            else {
                print("Record uploaded to cloud: \(String(describing: details))")
            }
            if url != nil {
            do {
                try FileManager.default.removeItem(at: url!)
            }
            catch let e { print("Error deleting temp file: \(e)") }
            }
        }
        modifyRecordsOperation.qualityOfService = .userInitiated
        privateDatabase.add(modifyRecordsOperation)
    }
     
    internal func uploadEditedGearToCloud(gear: NSManagedObject) {
        let details = gear.value(forKeyPath: "details") as? String
        let category = gear.value(forKeyPath: "category") as? String
        let majorCategory = gear.value(forKeyPath: "majorCategory") as? String
        let isSingle = gear.value(forKeyPath: "isSingle") as? Bool
        let isHalf = gear.value(forKeyPath: "isHalf") as? Bool
        let isTwin = gear.value(forKeyPath: "isTwin") as? Bool
        let isStatic = gear.value(forKeyPath: "isStatic") as? Bool
        let selfLength = gear.value(forKeyPath: "selfLength") as? String
        let selfWeight = gear.value(forKeyPath: "selfWeight") as? String
        let manufLength = gear.value(forKeyPath: "manufLength") as? String
        let manufWeight = gear.value(forKeyPath: "manufWeight") as? String
        let calculatedDensity = gear.value(forKeyPath: "calculatedDensity") as? String
        let manufDensity = gear.value(forKeyPath: "manufDensity") as? String
        let size = gear.value(forKeyPath: "size") as? String
        let notes = gear.value(forKeyPath: "notes") as? String
        let update = gear.value(forKeyPath: "update") as? NSDate
        let photoData = gear.value(forKeyPath: "photo") as? Data
        guard gear.value(forKeyPath: "gearID") != nil else {
            print ("gearID is nil, cannot upload")
            return
        }
        let gearID = gear.value(forKeyPath: "gearID") as! String
        
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecordID(recordName: gearID, zoneID: zoneID)
        
        let operation = CKFetchRecordsOperation(recordIDs: [recordID])
        operation.fetchRecordsCompletionBlock = {records, error in
            if let ckerror = error as? CKError {
                if ckerror.code == .unknownItem || ckerror.code == .partialFailure {
                    print("Record not found, attempting to upload: \(String(describing: details))")
                    self.uploadGearToCloud(gear: gear)
                }
                else {
                    print ("Error uploading edited record, adding to queue to upload edit: \(String(describing: details))")
                    print ("Error code: \(ckerror.localizedDescription)")
                    self.addIdToUploadEditQueue(id: gearID)
                }
            }
            else {
                let gearRecord = records?[recordID]
                var url: URL?
                if photoData != nil {
                    url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
                    do {
                        try photoData!.write(to: url!)
                    } catch let e as NSError {
                        print("Error! \(e)");
                        return
                    }
                    let asset = CKAsset(fileURL: url!)
                    gearRecord?.setObject(asset, forKey: "photo")
                }
                gearRecord?.setObject(details as CKRecordValue?, forKey: "details")
                gearRecord?.setObject(selfWeight as CKRecordValue?, forKey: "selfWeight")
                gearRecord?.setObject(manufWeight as CKRecordValue?, forKey: "manufWeight")
                gearRecord?.setObject(notes as CKRecordValue?, forKey: "notes")
                gearRecord?.setObject(category as CKRecordValue?, forKey: "category")
                gearRecord?.setObject(majorCategory as CKRecordValue?, forKey: "majorCategory")
                gearRecord?.setObject(size as CKRecordValue?, forKey: "size")
                gearRecord?.setObject(selfLength as CKRecordValue?, forKey: "selfLength")
                gearRecord?.setObject(manufLength as CKRecordValue?, forKey: "manufLength")
                gearRecord?.setObject(calculatedDensity as CKRecordValue?, forKey: "calculatedDensity")
                gearRecord?.setObject(manufDensity as CKRecordValue?, forKey: "manufDensity")
                gearRecord?.setObject(isSingle as CKRecordValue?, forKey: "isSingle")
                gearRecord?.setObject(isHalf as CKRecordValue?, forKey: "isHalf")
                gearRecord?.setObject(isTwin as CKRecordValue?, forKey: "isTwin")
                gearRecord?.setObject(isStatic as CKRecordValue?, forKey: "isStatic")
                gearRecord?.setObject(update as CKRecordValue?, forKey: "update")
                gearRecord?.setObject(gearID as CKRecordValue?, forKey: "gearID")
                
                let modifyRecordsOperation = CKModifyRecordsOperation(
                    recordsToSave: [gearRecord!], recordIDsToDelete: nil)
                modifyRecordsOperation.timeoutIntervalForRequest = 10
                modifyRecordsOperation.timeoutIntervalForResource = 10
                
                modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                    if error != nil {
                        print("Error uploading edited record, adding to queue: \(String(describing: details))")
                        if let cke = error as? CKError {
                            print ("Error code: \(cke.localizedDescription)")
                        }
                        self.addIdToUploadEditQueue(id: gearID)
                    }
                    else {
                            print("Edited record uploaded to cloud: \(String(describing: details))")
                            self.removeIdFromUploadEditQueue(id: gearID)
                            self.removeIdFromUploadQueue(id: gearID)
                    }
                    if url != nil {
                        do {
                            try FileManager.default.removeItem(at: url!)
                        }
                        catch let e { print("Error deleting temp file: \(e)") }
                    }
                }
                modifyRecordsOperation.qualityOfService = .userInitiated
                privateDatabase.add(modifyRecordsOperation)
            }
        }
    operation.qualityOfService = .userInitiated
    privateDatabase.add(operation)
    }
    
    internal func deleteGearFromCloud(gear: NSManagedObject) {
        guard gear.value(forKeyPath: "gearID") != nil else {
            print("gearID is nil, cannot delete from cloud")
            return
        }
        let gearID = gear.value(forKeyPath: "gearID") as! String
        
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let zoneID = CKRecordZoneID(zoneName: "GearZone", ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecordID(recordName: gearID, zoneID: zoneID)

        let operation = CKModifyRecordsOperation(recordsToSave: [], recordIDsToDelete: [recordID])
        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let ckerror = error as? CKError {
                if ckerror.code == .unknownItem || ckerror.code == .partialFailure {
                    print ("Record not found, removing from queue")
                }
                else {
                    print ("Error deleting record, adding to queue")
                    print ("Error code: \(ckerror.localizedDescription)")
                    self.addIdToDeleteQueue(id: gearID)
                }
            }
            else {
                    print("Record deleted in cloud")
                    self.removeIdFromUploadEditQueue(id: recordID.recordName)
                    self.removeIdFromUploadQueue(id: recordID.recordName)
            }
            }
        operation.qualityOfService = .userInitiated
        privateDatabase.add(operation)
    }
    
}


class ExtensionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
