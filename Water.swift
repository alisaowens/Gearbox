import UIKit
import os.log

class Water: NSObject, NSCoding {
    //MARK: Properties
    var waterDetails: String
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var capacity: String?
    var capacityCuIn: String?
    var photo: UIImage?
    var waterNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("waters")
    
    //MARK: Types
    struct PropertyKey{
        static let waterDetails = "waterDetails"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let capacity = "capacity"
        static let capacityCuIn = "capacityCuIn"
        static let photo = "photo"
        static let waterNotes = "waterNotes"
    }
    
    //MARK: Initialization
    init?(waterDetails: String, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, capacity: String?, capacityCuIn: String?, photo: UIImage?, waterNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(waterDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.waterDetails = waterDetails
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.capacity = capacity
        self.capacityCuIn = capacityCuIn
        self.photo = photo
        self.waterNotes = waterNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(waterDetails, forKey: PropertyKey.waterDetails)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(capacity, forKey: PropertyKey.capacity)
        aCoder.encode(capacityCuIn, forKey: PropertyKey.capacityCuIn)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(waterNotes, forKey: PropertyKey.waterNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The waterDetails is required. If we cannot decode a waterDetails string, the initializer should fail.
        guard let waterDetails = aDecoder.decodeObject(forKey: PropertyKey.waterDetails) as? String
            else{
                os_log("Unable to decode the waterDetails for a Water object", log: OSLog.default, type: .debug)
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
        let waterNotes = aDecoder.decodeObject(forKey: PropertyKey.waterNotes) as? String
        
        //Call designated initializer.
        self.init(waterDetails: waterDetails, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, capacity: capacity, capacityCuIn: capacityCuIn, photo: photo, waterNotes: waterNotes)
    }
}


