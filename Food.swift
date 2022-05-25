import UIKit
import os.log

class Food: NSObject, NSCoding {
    //MARK: Properties
    var foodDetails: String
    var category: String?
    var servingSize: String?
    var calories: String?
    var fat: String?
    var carbs: String?
    var protein: String?
    var foodNotes: String?
    var caloriesPerGram: String?
    var fatPerGram: String?
    var carbsPerGram: String?
    var proteinPerGram: String?
    var photo: UIImage?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("foods")
    
    //MARK: Types
    struct PropertyKey{
        static let foodDetails = "foodDetails"
        static let category = "category"
        static let servingSize = "servingSize"
        static let calories = "calories"
        static let fat = "fat"
        static let carbs = "carbs"
        static let protein = "protein"
        static let foodNotes = "foodNotes"
        static let caloriesPerGram = "caloriesPerGram"
        static let fatPerGram = "fatPerGram"
        static let carbsPerGram = "carbsPerGram"
        static let proteinPerGram = "proteinPerGram"
        static let photo = "photo"
    }
    
    //MARK: Initialization
    init?(foodDetails: String, category: String?, servingSize: String?, calories: String?, fat: String?, carbs: String?, protein: String?, foodNotes: String?, caloriesPerGram: String?, fatPerGram: String?, carbsPerGram: String?, proteinPerGram: String?, photo: UIImage?){
        //Initialization should fail if there is no foodDetails
        guard !(foodDetails.isEmpty) else {
            return nil
        }
        //Initialize stored properties
        self.foodDetails = foodDetails
        self.category = category
        self.servingSize = servingSize
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.foodNotes = foodNotes
        self.caloriesPerGram = caloriesPerGram
        self.fatPerGram = fatPerGram
        self.carbsPerGram = carbsPerGram
        self.proteinPerGram = proteinPerGram
        self.photo = photo
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(foodDetails, forKey: PropertyKey.foodDetails)
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(servingSize, forKey: PropertyKey.servingSize)
        aCoder.encode(calories, forKey: PropertyKey.calories)
        aCoder.encode(fat, forKey: PropertyKey.fat)
        aCoder.encode(carbs, forKey: PropertyKey.carbs)
        aCoder.encode(protein, forKey: PropertyKey.protein)
        aCoder.encode(foodNotes, forKey: PropertyKey.foodNotes)
        aCoder.encode(caloriesPerGram, forKey: PropertyKey.caloriesPerGram)
        aCoder.encode(fatPerGram, forKey: PropertyKey.fatPerGram)
        aCoder.encode(carbsPerGram, forKey: PropertyKey.carbsPerGram)
        aCoder.encode(proteinPerGram, forKey: PropertyKey.proteinPerGram)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        //The foodDetails is required. If we cannot decode a foodDetails string, the initializer should fail.
        guard let foodDetails = aDecoder.decodeObject(forKey: PropertyKey.foodDetails) as? String
            else{
                os_log("Unable to decode the foodDetails for a Food object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //For optional properties of Food, just use conditional cast
        let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String
        let servingSize = aDecoder.decodeObject(forKey: PropertyKey.servingSize) as? String
        let calories = aDecoder.decodeObject(forKey: PropertyKey.calories) as? String
        let fat = aDecoder.decodeObject(forKey: PropertyKey.fat) as? String
        let carbs = aDecoder.decodeObject(forKey: PropertyKey.carbs) as? String
        let protein = aDecoder.decodeObject(forKey: PropertyKey.protein) as? String
        let foodNotes = aDecoder.decodeObject(forKey: PropertyKey.foodNotes) as? String
        let caloriesPerGram = aDecoder.decodeObject(forKey: PropertyKey.caloriesPerGram) as? String
        let fatPerGram = aDecoder.decodeObject(forKey: PropertyKey.fatPerGram) as? String
        let carbsPerGram = aDecoder.decodeObject(forKey: PropertyKey.carbsPerGram) as? String
        let proteinPerGram = aDecoder.decodeObject(forKey: PropertyKey.proteinPerGram) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //Call designated initializer.
        self.init(foodDetails: foodDetails, category: category, servingSize: servingSize, calories: calories, fat: fat, carbs: carbs, protein: protein, foodNotes: foodNotes, caloriesPerGram: caloriesPerGram, fatPerGram: fatPerGram, carbsPerGram: carbsPerGram, proteinPerGram: proteinPerGram, photo: photo)
    }
}

