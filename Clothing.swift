import UIKit
import os.log

class Clothing: NSObject, NSCoding {
    //MARK: Properties
    var clothingDetails: String
    var category: String?
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var clothingNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("clothing")
    
    //MARK: Types
    struct PropertyKey{
        static let clothingDetails = "clothingDetails"
        static let category = "category"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let clothingNotes = "clothingNotes"
    }
    
    //MARK: Initialization
    init?(clothingDetails: String, category: String?,  selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, clothingNotes: String?){
        //Initialization should fail if there is no details
        guard !(clothingDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.clothingDetails = clothingDetails
        self.category = category
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.clothingNotes = clothingNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(clothingDetails, forKey: PropertyKey.clothingDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(clothingNotes, forKey: PropertyKey.clothingNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The details is required. If we cannot decode a details string, the initializer should fail.
        guard let clothingDetails = aDecoder.decodeObject(forKey: PropertyKey.clothingDetails) as? String
            else{
                os_log("Unable to decode the details for a clothing object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let clothingNotes = aDecoder.decodeObject(forKey: PropertyKey.clothingNotes) as? String
        
        //Call designated initializer.
        self.init(clothingDetails: clothingDetails, category: category, selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, clothingNotes: clothingNotes)
    }
}



