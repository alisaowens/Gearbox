import UIKit
import os.log

class Lighting: NSObject, NSCoding {
    //MARK: Properties
    var lightingDetails: String
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var lightingNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lightings")
    
    //MARK: Types
    struct PropertyKey{
        static let lightingDetails = "lightingDetails"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let lightingNotes = "lightingNotes"
    }
    
    //MARK: Initialization
    init?(lightingDetails: String, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, lightingNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(lightingDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.lightingDetails = lightingDetails
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.lightingNotes = lightingNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(lightingDetails, forKey: PropertyKey.lightingDetails)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(lightingNotes, forKey: PropertyKey.lightingNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The lightingDetails is required. If we cannot decode a lightingDetails string, the initializer should fail.
        guard let lightingDetails = aDecoder.decodeObject(forKey: PropertyKey.lightingDetails) as? String
            else{
                os_log("Unable to decode the lightingDetails for a Lighting object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let lightingNotes = aDecoder.decodeObject(forKey: PropertyKey.lightingNotes) as? String
        
        //Call designated initializer.
        self.init(lightingDetails: lightingDetails, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, lightingNotes: lightingNotes)
    }
}


