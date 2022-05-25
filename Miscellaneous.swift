import UIKit
import os.log

class Miscellaneous: NSObject, NSCoding {
    //MARK: Properties
    var miscellaneousDetails: String
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var miscellaneousNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("miscellaneouss")
    
    //MARK: Types
    struct PropertyKey{
        static let miscellaneousDetails = "miscellaneousDetails"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let miscellaneousNotes = "miscellaneousNotes"
    }
    
    //MARK: Initialization
    init?(miscellaneousDetails: String, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, miscellaneousNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(miscellaneousDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.miscellaneousDetails = miscellaneousDetails
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.miscellaneousNotes = miscellaneousNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(miscellaneousDetails, forKey: PropertyKey.miscellaneousDetails)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(miscellaneousNotes, forKey: PropertyKey.miscellaneousNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The miscellaneousDetails is required. If we cannot decode a miscellaneousDetails string, the initializer should fail.
        guard let miscellaneousDetails = aDecoder.decodeObject(forKey: PropertyKey.miscellaneousDetails) as? String
            else{
                os_log("Unable to decode the miscellaneousDetails for a Miscellaneous object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let miscellaneousNotes = aDecoder.decodeObject(forKey: PropertyKey.miscellaneousNotes) as? String
        
        //Call designated initializer.
        self.init(miscellaneousDetails: miscellaneousDetails, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, miscellaneousNotes: miscellaneousNotes)
    }
}


