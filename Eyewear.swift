import UIKit
import os.log

class Eyewear: NSObject, NSCoding {
    //MARK: Properties
    var eyewearDetails: String
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var eyewearNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("eyewears")
    
    //MARK: Types
    struct PropertyKey{
        static let eyewearDetails = "eyewearDetails"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let eyewearNotes = "eyewearNotes"
    }
    
    //MARK: Initialization
    init?(eyewearDetails: String, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, eyewearNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(eyewearDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.eyewearDetails = eyewearDetails
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.eyewearNotes = eyewearNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(eyewearDetails, forKey: PropertyKey.eyewearDetails)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(eyewearNotes, forKey: PropertyKey.eyewearNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The eyewearDetails is required. If we cannot decode a eyewearDetails string, the initializer should fail.
        guard let eyewearDetails = aDecoder.decodeObject(forKey: PropertyKey.eyewearDetails) as? String
            else{
                os_log("Unable to decode the eyewearDetails for a Eyewear object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let eyewearNotes = aDecoder.decodeObject(forKey: PropertyKey.eyewearNotes) as? String
        
        //Call designated initializer.
        self.init(eyewearDetails: eyewearDetails, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, eyewearNotes: eyewearNotes)
    }
}


