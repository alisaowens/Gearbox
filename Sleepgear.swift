import UIKit
import os.log

class Sleepgear: NSObject, NSCoding {
    //MARK: Properties
    var sleepgearDetails: String
    var category: String?
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var sleepgearNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("sleepgear")
    
    //MARK: Types
    struct PropertyKey{
        static let sleepgearDetails = "sleepgearDetails"
        static let category = "category"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let sleepgearNotes = "sleepgearNotes"
    }
    
    //MARK: Initialization
    init?(sleepgearDetails: String, category: String?,  selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, sleepgearNotes: String?){
        //Initialization should fail if there is no details
        guard !(sleepgearDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.sleepgearDetails = sleepgearDetails
        self.category = category
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.sleepgearNotes = sleepgearNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(sleepgearDetails, forKey: PropertyKey.sleepgearDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(sleepgearNotes, forKey: PropertyKey.sleepgearNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The details is required. If we cannot decode a details string, the initializer should fail.
        guard let sleepgearDetails = aDecoder.decodeObject(forKey: PropertyKey.sleepgearDetails) as? String
            else{
                os_log("Unable to decode the details for a sleepgear object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let sleepgearNotes = aDecoder.decodeObject(forKey: PropertyKey.sleepgearNotes) as? String
        
        //Call designated initializer.
        self.init(sleepgearDetails: sleepgearDetails, category: category, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, sleepgearNotes: sleepgearNotes)
    }
}



