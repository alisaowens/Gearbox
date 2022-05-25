import UIKit
import os.log

class Helmet: NSObject, NSCoding {
    //MARK: Properties
    var helmetDetails: String
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var helmetNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("helmets")
    
    //MARK: Types
    struct PropertyKey{
        static let helmetDetails = "helmetDetails"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let helmetNotes = "helmetNotes"
    }
    
    //MARK: Initialization
    init?(helmetDetails: String, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, helmetNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(helmetDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.helmetDetails = helmetDetails
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.helmetNotes = helmetNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(helmetDetails, forKey: PropertyKey.helmetDetails)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(helmetNotes, forKey: PropertyKey.helmetNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The helmetDetails is required. If we cannot decode a helmetDetails string, the initializer should fail.
        guard let helmetDetails = aDecoder.decodeObject(forKey: PropertyKey.helmetDetails) as? String
            else{
                os_log("Unable to decode the helmetDetails for a Helmet object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let helmetNotes = aDecoder.decodeObject(forKey: PropertyKey.helmetNotes) as? String
        
        //Call designated initializer.
        self.init(helmetDetails: helmetDetails, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, helmetNotes: helmetNotes)
    }
}


