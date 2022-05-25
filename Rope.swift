import UIKit
import os.log

class Rope: NSObject, NSCoding {
    //MARK: Properties
    var ropeDetails: String
    var isSingle: Bool
    var isHalf: Bool
    var isTwin: Bool
    var isStatic: Bool
    var selfLength: String?
    var selfWeight: String?
    var manufLength: String?
    var calculatedDensity: String?
    var manufDensity: String?
    var manufWeight: String?
    var manufWeightLb: String?
    var manufWeightOz: String?
    var diameter: String?
    var photo: UIImage?
    var ropeNotes: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ropes")
    
    //MARK: Types
    struct PropertyKey{
        static let ropeDetails = "ropeDetails"
        static let isSingle = "isSingle"
        static let isHalf = "isHalf"
        static let isTwin = "isTwin"
        static let isStatic = "isStatic"
        static let selfLength = "selfLength"
        static let selfWeight = "selfWeight"
        static let manufLength = "manufLength"
        static let calculatedDensity = "calculatedDensity"
        static let manufDensity = "manufDensity"
        static let manufWeight = "manufWeight"
        static let manufWeightLb = "manufWeightLb"
        static let manufWeightOz = "manufWeightOz"
        static let diameter = "diameter"
        static let photo = "photo"
        static let ropeNotes = "notes"
    }

//MARK: Initialization
    init?(ropeDetails: String, isSingle: Bool, isHalf: Bool, isTwin: Bool, isStatic: Bool, selfLength: String?, selfWeight: String?, manufLength: String?, calculatedDensity: String?, manufDensity: String?, manufWeight: String?, manufWeightLb: String?, manufWeightOz: String?, diameter: String?, photo: UIImage?, ropeNotes: String?){
    //Initialization should fail if there is ropeDetails
        guard !(ropeDetails.isEmpty) else {
    return nil
    }
    //Initialize stored properties
        self.ropeDetails = ropeDetails
        self.isSingle = isSingle
        self.isHalf = isHalf
        self.isTwin = isTwin
        self.isStatic = isStatic
        self.selfLength = selfLength
        self.selfWeight = selfWeight
        self.manufLength = manufLength
        self.calculatedDensity = calculatedDensity
        self.manufDensity = manufDensity
        self.manufWeight = manufWeight
        self.manufWeightLb = manufWeightLb
        self.manufWeightOz = manufWeightOz
        self.diameter = diameter
        self.photo = photo
        self.ropeNotes = ropeNotes
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(ropeDetails, forKey: PropertyKey.ropeDetails)
        aCoder.encode(isSingle, forKey: PropertyKey.isSingle)
        aCoder.encode(isHalf, forKey: PropertyKey.isHalf)
        aCoder.encode(isTwin, forKey: PropertyKey.isTwin)
        aCoder.encode(isStatic, forKey: PropertyKey.isStatic)
        aCoder.encode(selfLength, forKey: PropertyKey.selfLength)
        aCoder.encode(selfWeight, forKey: PropertyKey.selfWeight)
        aCoder.encode(manufLength, forKey: PropertyKey.manufLength)
        aCoder.encode(calculatedDensity, forKey: PropertyKey.calculatedDensity)
        aCoder.encode(manufDensity, forKey: PropertyKey.manufDensity)
        aCoder.encode(manufWeight, forKey: PropertyKey.manufWeight)
        aCoder.encode(manufWeightLb, forKey: PropertyKey.manufWeightLb)
        aCoder.encode(manufWeightOz, forKey: PropertyKey.manufWeightOz)
        aCoder.encode(diameter, forKey: PropertyKey.diameter)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(ropeNotes, forKey: PropertyKey.ropeNotes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The ropeDetails is required. If we cannot decode a ropeDetails string, the initializer should fail.
        guard let ropeDetails = aDecoder.decodeObject(forKey: PropertyKey.ropeDetails) as? String
            else{
     //           os_log("Unable to decode the ropeDetails for a Rope object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Rope, just use conditional cast
        let isSingle = aDecoder.decodeBool(forKey: PropertyKey.isSingle) as Bool
        let isHalf = aDecoder.decodeBool(forKey: PropertyKey.isHalf) as Bool
        let isTwin = aDecoder.decodeBool(forKey: PropertyKey.isTwin) as Bool
        let isStatic = aDecoder.decodeBool(forKey: PropertyKey.isStatic) as Bool
        let selfLength = aDecoder.decodeObject(forKey: PropertyKey.selfLength) as? String
        let selfWeight = aDecoder.decodeObject(forKey: PropertyKey.selfWeight) as? String
        let manufLength = aDecoder.decodeObject(forKey: PropertyKey.manufLength) as? String
        let calculatedDensity = aDecoder.decodeObject(forKey: PropertyKey.calculatedDensity) as? String
        let manufDensity = aDecoder.decodeObject(forKey: PropertyKey.manufDensity) as? String
        let manufWeight = aDecoder.decodeObject(forKey: PropertyKey.manufWeight) as? String
        let manufWeightLb = aDecoder.decodeObject(forKey: PropertyKey.manufWeightLb) as? String
        let manufWeightOz = aDecoder.decodeObject(forKey: PropertyKey.manufWeightOz) as? String
        let diameter = aDecoder.decodeObject(forKey: PropertyKey.diameter) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let ropeNotes = aDecoder.decodeObject(forKey: PropertyKey.ropeNotes) as? String
        
        //Call designated initializer.
        self.init(ropeDetails: ropeDetails, isSingle: isSingle, isHalf: isHalf, isTwin: isTwin, isStatic: isStatic, selfLength: selfLength, selfWeight: selfWeight, manufLength: manufLength, calculatedDensity:  calculatedDensity, manufDensity: manufDensity, manufWeight: manufWeight, manufWeightLb: manufWeightLb, manufWeightOz: manufWeightOz, diameter: diameter, photo: photo, ropeNotes: ropeNotes)
    }
}
