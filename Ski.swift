import UIKit
import os.log

class Ski: NSObject, NSCoding {
    //MARK: Properties
    var skiDetails: String
    var category: String?
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var skiNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("skis")
    
    //MARK: Types
    struct PropertyKey{
        static let skiDetails = "skiDetails"
        static let category = "category"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let skiNotes = "skiNotes"
    }
    
    //MARK: Initialization
    init?(skiDetails: String, category: String?, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, skiNotes: String?){
        //Initialization should fail if there is no skiDetails
        guard !(skiDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.skiDetails = skiDetails
        self.category = category
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.skiNotes = skiNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(skiDetails, forKey: PropertyKey.skiDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(skiNotes, forKey: PropertyKey.skiNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The skiDetails is required. If we cannot decode a skiDetails string, the initializer should fail.
        guard let skiDetails = aDecoder.decodeObject(forKey: PropertyKey.skiDetails) as? String
            else{
                os_log("Unable to decode the skiDetails for a Ski object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Ski, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let skiNotes = aDecoder.decodeObject(forKey: PropertyKey.skiNotes) as? String
        
        //Call designated initializer.
        self.init(skiDetails: skiDetails, category: category,  selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, skiNotes: skiNotes)
    }
}


