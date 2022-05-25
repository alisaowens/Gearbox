import UIKit
import os.log

class Hardware: NSObject, NSCoding {
    //MARK: Properties
    var hardwareDetails: String
    var category: String?
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var hardwareNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("hardware")
    
    //MARK: Types
    struct PropertyKey{
        static let hardwareDetails = "hardwareDetails"
        static let category = "category"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let hardwareNotes = "hardwareNotes"
    }
    
    //MARK: Initialization
    init?(hardwareDetails: String, category: String?, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, hardwareNotes: String?){
        //Initialization should fail if there is no details
        guard !(hardwareDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.hardwareDetails = hardwareDetails
        self.category = category
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.hardwareNotes = hardwareNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(hardwareDetails, forKey: PropertyKey.hardwareDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(hardwareNotes, forKey: PropertyKey.hardwareNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The details is required. If we cannot decode a details string, the initializer should fail.
        guard let hardwareDetails = aDecoder.decodeObject(forKey: PropertyKey.hardwareDetails) as? String
            else{
                os_log("Unable to decode the details for a hardware object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let hardwareNotes = aDecoder.decodeObject(forKey: PropertyKey.hardwareNotes) as? String
        
        //Call designated initializer.
        self.init(hardwareDetails: hardwareDetails, category: category,  selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, hardwareNotes: hardwareNotes)
    }
}




