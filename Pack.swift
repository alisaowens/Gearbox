import UIKit
import os.log

class Pack: NSObject, NSCoding {
    //MARK: Properties
    var packDetails: String
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var capacity: String?
    var capacityCuIn: String?
    var photo: UIImage?
    var packNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("packs")
    
    //MARK: Types
    struct PropertyKey{
        static let packDetails = "packDetails"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let capacity = "capacity"
        static let capacityCuIn = "capacityCuIn"
        static let photo = "photo"
        static let packNotes = "packNotes"
    }
    
    //MARK: Initialization
    init?(packDetails: String, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, capacity: String?, capacityCuIn: String?, photo: UIImage?, packNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(packDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.packDetails = packDetails
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.capacity = capacity
        self.capacityCuIn = capacityCuIn
        self.photo = photo
        self.packNotes = packNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(packDetails, forKey: PropertyKey.packDetails)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(capacity, forKey: PropertyKey.capacity)
        aCoder.encode(capacityCuIn, forKey: PropertyKey.capacityCuIn)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(packNotes, forKey: PropertyKey.packNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The packDetails is required. If we cannot decode a packDetails string, the initializer should fail.
        guard let packDetails = aDecoder.decodeObject(forKey: PropertyKey.packDetails) as? String
            else{
                os_log("Unable to decode the packDetails for a Pack object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let capacity = aDecoder.decodeObject(forKey: PropertyKey.capacity) as? String
        let capacityCuIn = aDecoder.decodeObject(forKey: PropertyKey.capacityCuIn) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let packNotes = aDecoder.decodeObject(forKey: PropertyKey.packNotes) as? String
        
        //Call designated initializer.
        self.init(packDetails: packDetails, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, capacity: capacity, capacityCuIn: capacityCuIn, photo: photo, packNotes: packNotes)
    }
}


