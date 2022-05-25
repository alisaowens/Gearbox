import UIKit
import os.log

class Ice: NSObject, NSCoding {
    //MARK: Properties
    
    var iceDetails: String
    var category: String?
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var iceNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ices")
    
    //MARK: Types
    struct PropertyKey{
        static let iceDetails = "iceDetails"
        static let category = "category"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let iceNotes = "iceNotes"
    }
    
    //MARK: Initialization
    init?(iceDetails: String, category: String?, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, iceNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(iceDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.iceDetails = iceDetails
        self.category = category
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.iceNotes = iceNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(iceDetails, forKey: PropertyKey.iceDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(iceNotes, forKey: PropertyKey.iceNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The iceDetails is required. If we cannot decode a iceDetails string, the initializer should fail.
        guard let iceDetails = aDecoder.decodeObject(forKey: PropertyKey.iceDetails) as? String
            else{
                os_log("Unable to decode the iceDetails for a Ice object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let iceNotes = aDecoder.decodeObject(forKey: PropertyKey.iceNotes) as? String
        
        //Call designated initializer.
        self.init(iceDetails: iceDetails, category: category,  selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, iceNotes: iceNotes)
    }
}



