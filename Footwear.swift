import UIKit
import os.log

class Footwear: NSObject, NSCoding {
    //MARK: Properties
    var footwearDetails: String
    var category: String?
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var size: String?
    var photo: UIImage?
    var footwearNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("footwear")
    
    //MARK: Types
    struct PropertyKey{
        static let footwearDetails = "footwearDetails"
        static let category = "category"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let size = "size"
        static let photo = "photo"
        static let footwearNotes = "footwearNotes"
    }
    
    //MARK: Initialization
    init?(footwearDetails: String, category: String?, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, size: String?, photo: UIImage?, footwearNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(footwearDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.footwearDetails = footwearDetails
        self.category = category
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.size = size
        self.photo = photo
        self.footwearNotes = footwearNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(footwearDetails, forKey: PropertyKey.footwearDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(size, forKey: PropertyKey.size)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(footwearNotes, forKey: PropertyKey.footwearNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The footwearDetails is required. If we cannot decode a footwearDetails string, the initializer should fail.
        guard let footwearDetails = aDecoder.decodeObject(forKey: PropertyKey.footwearDetails) as? String
            else{
                os_log("Unable to decode the footwearDetails for a Footwear object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let size = aDecoder.decodeObject(forKey: PropertyKey.size) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let footwearNotes = aDecoder.decodeObject(forKey: PropertyKey.footwearNotes) as? String
        
        //Call designated initializer.
        self.init(footwearDetails: footwearDetails, category: category, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, size: size, photo: photo, footwearNotes: footwearNotes)
    }
}


