import UIKit
import os.log

class Cooking: NSObject, NSCoding {
    //MARK: Properties
    
    var cookingDetails: String
    var category: String?
    var selfWeight: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var photo: UIImage?
    var cookingNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cookings")
    
    //MARK: Types
    struct PropertyKey{
        static let cookingDetails = "cookingDetails"
        static let category = "category"
        static let selfWeight = "selfWeight"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let photo = "photo"
        static let cookingNotes = "cookingNotes"
    }
    
    //MARK: Initialization
    init?(cookingDetails: String, category: String?, selfWeight: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, photo: UIImage?, cookingNotes: String?){
        //Initialization should fail if there is no footwearDetails
        guard !(cookingDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.cookingDetails = cookingDetails
        self.category = category
        self.selfWeight = selfWeight
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.photo = photo
        self.cookingNotes = cookingNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(cookingDetails, forKey: PropertyKey.cookingDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(cookingNotes, forKey: PropertyKey.cookingNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The cookingDetails is required. If we cannot decode a cookingDetails string, the initializer should fail.
        guard let cookingDetails = aDecoder.decodeObject(forKey: PropertyKey.cookingDetails) as? String
            else{
                os_log("Unable to decode the cookingDetails for a Cooking object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let cookingNotes = aDecoder.decodeObject(forKey: PropertyKey.cookingNotes) as? String
        
        //Call designated initializer.
        self.init(cookingDetails: cookingDetails,  category: category,  selfWeight: selfWeight, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, photo: photo, cookingNotes: cookingNotes)
    }
}




