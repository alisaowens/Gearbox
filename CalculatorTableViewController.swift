import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class CalculatorTableViewController: UITableViewController {
    
    var gearIDs: [String] = []
    var gear: [NSManagedObject] = []
    var qtys: [Int] = []
    var weights: [Float] = []
    
    @IBOutlet weak var sumButton: UIBarButtonItem!
    var sumOfWeights = Float(0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func majorCategoryButton(_ sender: UIButton) {
        let subStackView = sender.superview
        let stackView = subStackView?.superview
        let contentView = stackView?.superview
        let cell = contentView?.superview as! CalculatorTableViewCell
        
        let majorCategoryAlert = UIAlertController (title: "Category:", message: "", preferredStyle: .actionSheet)
        let clothingAction = UIAlertAction(title: "Clothing", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Clothing", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Clothing"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let footwearAction = UIAlertAction(title: "Footwear", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Footwear", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Footwear"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let sleepgearAction = UIAlertAction(title: "Sleeping Gear", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Sleeping Gear", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Sleepgear"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let hardwareAction = UIAlertAction(title: "Climbing Hardware", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Hardware", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Hardware"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let ropesAction = UIAlertAction(title: "Ropes", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Ropes", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Ropes"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let foodAction = UIAlertAction(title: "Foods", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Foods", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Food"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let iceAction = UIAlertAction(title: "Ice Gear", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Ice Gear", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Ice"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let cookingAction = UIAlertAction(title: "Cooking Gear", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Cooking Gear", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Cooking"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let skiAction = UIAlertAction(title: "Ski Gear", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Ski Gear", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Skigear"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let electronicsAction = UIAlertAction(title: "Electronics", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Electronics", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.categoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categoryButton.isHidden = false
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Electronics"
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let packAction = UIAlertAction(title: "Packs", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Packs", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.itemButton.setTitle("Select item", for: .normal)
            cell.itemButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.itemButton.isHidden = false
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.categoryButton.isHidden = true
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Packs"
            cell.gearOptions = self.getGearWithMajorCategory(majorCategory: "Packs")
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let miscellaneousAction = UIAlertAction(title: "Miscellaneous", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Miscellaneous", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.itemButton.setTitle("Select item", for: .normal)
            cell.itemButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.itemButton.isHidden = false
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.categoryButton.isHidden = true
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Miscellaneous"
            cell.gearOptions = self.getGearWithMajorCategory(majorCategory: "Miscellaneous")
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let eyewearAction = UIAlertAction(title: "Eyewear", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Eyewear", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.itemButton.setTitle("Select item", for: .normal)
            cell.itemButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.itemButton.isHidden = false
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.categoryButton.isHidden = true
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Eyewear"
            cell.gearOptions = self.getGearWithMajorCategory(majorCategory: "Eyewear")
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let helmetsAction = UIAlertAction(title: "Helmets", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Helmets", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.itemButton.setTitle("Select item", for: .normal)
            cell.itemButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.itemButton.isHidden = false
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.categoryButton.isHidden = true
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Helmets"
            cell.gearOptions = self.getGearWithMajorCategory(majorCategory: "Helmets")
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let lightingAction = UIAlertAction(title: "Lighting", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Lighting", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.itemButton.setTitle("Select item", for: .normal)
            cell.itemButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.itemButton.isHidden = false
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.categoryButton.isHidden = true
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Lighting"
            cell.gearOptions = self.getGearWithMajorCategory(majorCategory: "Lighting")
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        let waterAction = UIAlertAction(title: "Water Storage", style: .default) {(action) in
            cell.majorCategoryButton.setTitle("Water Storage", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            cell.itemButton.setTitle("Select item", for: .normal)
            cell.itemButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.itemButton.isHidden = false
            cell.qtyButton.isHidden = true
            cell.qtyButton.setTitle("Qty: 1", for: .normal)
            cell.categoryButton.isHidden = true
            cell.categoryButton.setTitle("Select subcategory", for: .normal)
            cell.weightLabel.isHidden = true
            cell.majorCategory = "Water"
            cell.gearOptions = self.getGearWithMajorCategory(majorCategory: "Water")
            cell.category = ""
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
        }
        
        if let popoverController = majorCategoryAlert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        majorCategoryAlert.addAction(clothingAction)
        majorCategoryAlert.addAction(cookingAction)
        majorCategoryAlert.addAction(electronicsAction)
        majorCategoryAlert.addAction(eyewearAction)
        majorCategoryAlert.addAction(foodAction)
        majorCategoryAlert.addAction(footwearAction)
        majorCategoryAlert.addAction(hardwareAction)
        majorCategoryAlert.addAction(helmetsAction)
        majorCategoryAlert.addAction(iceAction)
        majorCategoryAlert.addAction(lightingAction)
        majorCategoryAlert.addAction(miscellaneousAction)
        majorCategoryAlert.addAction(packAction)
        majorCategoryAlert.addAction(ropesAction)
        majorCategoryAlert.addAction(skiAction)
        majorCategoryAlert.addAction(sleepgearAction)
        majorCategoryAlert.addAction(waterAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            majorCategoryAlert.dismiss(animated:true,completion:nil)
        }
        majorCategoryAlert.addAction(cancelAction)
        self.present(majorCategoryAlert, animated: true)
    }
    
    @IBAction func categoryButton(_ sender: UIButton) {
        let subStackView = sender.superview
        let stackView = subStackView?.superview
        let contentView = stackView?.superview
        let cell = contentView?.superview as! CalculatorTableViewCell
        switch cell.majorCategory {
        case "Ropes":
            cell.categories = ["Single","Half","Twin","Static"]
        case "Food":
            cell.categories = ["Bars","Gels","Powders","Freeze-dried","Other Food"]
        case "Footwear":
            cell.categories = ["Ski Boots","Mountain Boots","Trail Shoes","Rock Shoes","Other Footwear"]
        case "Sleepgear":
            cell.categories = ["Tents","Bivy Sacks & Tarps","Sleeping Bags","Sleeping Pads","Other Sleeping Gear"]
        case "Hardware":
            cell.categories = ["Locking Carabiners","Non-locking Carabiners","Slings & Quickdraws","Chocks","Cams","Pitons","Ice Screws","Other Protection","Harnesses","Belay & Rappel","Ascenders & Pulleys","Aid Gear","Other Hardware"]
        case "Ice":
            cell.categories = ["Ice Axes","Crampons","Leashes","Other Ice Gear"]
        case "Cooking":
            cell.categories = ["Stoves","Pots","Fuel","Other Cooking Gear"]
        case "Skigear":
            cell.categories = ["Skis","Skins","Poles","Ski Crampons","Bindings","Shovels","Probes","Transceivers","Other Ski Gear"]
        case "Electronics":
            cell.categories = ["Cameras","Phones","GPS","Watches","Batteries","Music Players","Other Electronics"]
        case "Clothing":
            cell.categories = ["Hats & Balaclavas","Tops - Baselayer","Tops - Insulation","Tops - Shell","Bottoms - Baselayer","Bottoms - Insulation","Bottoms - Shell","Socks","Gloves","Gaiters","Other Clothing"]
        default:
            fatalError("Major category not found")
        }
        let categoryAlert = UIAlertController (title: "Subcategory:", message: "", preferredStyle: .actionSheet)
        if let popoverController = categoryAlert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        for category in cell.categories {
            let action = UIAlertAction(title: category, style: .default) {(action) in
                cell.categoryButton.setTitle(category, for: .normal)
                cell.categoryButton.setTitleColor(UIColor.black, for: .normal)
                cell.itemButton.setTitle("Select item", for: .normal)
                cell.itemButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
                cell.itemButton.isHidden = false
                cell.category = category
                cell.qtyButton.isHidden = true
                cell.qtyButton.setTitle("Qty: 1", for: .normal)
                cell.weightLabel.isHidden = true
                if cell.majorCategory == "Ropes" {
                    cell.gearOptions = self.getRopeWithCategory(category: category)
                }
                else {
                    cell.gearOptions = self.getGearWithCategory(category: category)
                }
                cell.gearItem = nil
                cell.qty = 1
                cell.weight = Float(0)
            }
            categoryAlert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            categoryAlert.dismiss(animated:true,completion:nil)
        }
        categoryAlert.addAction(cancelAction)
        self.present(categoryAlert, animated: true)
    }

    @IBAction func itemButton(_ sender: UIButton) {
        let subStackView = sender.superview
        let stackView = subStackView?.superview
        let contentView = stackView?.superview
        let cell = contentView?.superview as! CalculatorTableViewCell
        var message = ""
        if cell.gearOptions.isEmpty {
            message = "You have not yet added any gear in this category"
        }
        let itemAlert = UIAlertController (title: "Items:", message: message, preferredStyle: .actionSheet)
        if let popoverController = itemAlert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        for gearItem in cell.gearOptions {
            let details = gearItem.value(forKeyPath: "details") as? String
            let gearID = gearItem.value(forKeyPath: "gearID") as? String
            guard gearID != nil else {
                print("gearID is nil")
                return
            }
            guard let index = self.tableView.indexPath(for: cell) else {
                print ("index path not found")
                return
            }
            let action = UIAlertAction(title: details, style: .default) {(action) in
                if cell.gearItem == nil {
                    self.gear.append(gearItem)
                    self.qtys.append(cell.qty)
                    self.gearIDs.append(gearID!)
                }
                else {
                    self.gear[index.row] = gearItem
                    self.gearIDs[index.row] = gearID!
                }
                cell.itemButton.setTitle(details, for: .normal)
                cell.itemButton.setTitleColor(UIColor.black, for: .normal)
                cell.qtyButton.setTitle("Qty: " + String(cell.qty), for: .normal)
                cell.qtyButton.isHidden = false
                var selfWeight: String?
                if cell.majorCategory == "Food" {
                    selfWeight = gearItem.value(forKeyPath: "selfLength") as? String
                }
                else {
                    selfWeight = gearItem.value(forKeyPath: "selfWeight") as? String
                }
                let manufWeight = gearItem.value(forKeyPath: "manufWeight") as? String
                if let weightOfItem = Float(selfWeight!){
                    cell.weight = weightOfItem * Float(cell.qty)
                    cell.weightLabel.textColor = UIColor.black
                }
                else if let weightOfItem = Float(manufWeight!){
                    cell.weight = weightOfItem * Float(cell.qty)
                    cell.weightLabel.textColor = UIColor(red: 0.498, green: 0, blue: 0, alpha: 1)
                }
                if index.row >= self.weights.count {
                    self.weights.append(cell.weight)
                }
                else {
                    self.weights[index.row] = cell.weight
                }
                cell.weightLabel.text = String(format: "%.0f", cell.weight) + " g"
                cell.weightLabel.isHidden = false
                cell.gearItem = gearItem
                cell.gearID = gearID!
                let IndexPathOfLastRow = NSIndexPath(row: self.gear.count, section: 0)
                let rowCount = self.tableView.numberOfRows(inSection: 0)
                if rowCount == IndexPathOfLastRow.row {
                    self.tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableViewRowAnimation.left)
                }
                self.tableView.reloadData()
                self.updatePackWeight()
            }
            itemAlert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            itemAlert.dismiss(animated:true,completion:nil)
        }
        itemAlert.addAction(cancelAction)
        self.present(itemAlert, animated: true)
    }
    
    @IBAction func qtyButton(_ sender: UIButton) {
        let subStackView = sender.superview
        let stackView = subStackView?.superview
        let contentView = stackView?.superview
        let cell = contentView?.superview as! CalculatorTableViewCell
        let selfWeight = cell.gearItem?.value(forKeyPath: "selfWeight") as? String
        let manufWeight = cell.gearItem?.value(forKeyPath: "manufWeight") as? String
        let selfLength = cell.gearItem?.value(forKeyPath: "selfLength") as? String
        let quantity = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
        
        let qtyAlert = UIAlertController (title: "Quantity:", message: "", preferredStyle: .actionSheet)
        if let popoverController = qtyAlert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        for number in quantity {
            let action = UIAlertAction(title: number, style: .default) {(action) in
                guard let index = self.tableView.indexPath(for: cell) else {
                    print ("index path not found")
                    return
                }
                self.qtys[index.row] = Int(number)!
                cell.qtyButton.setTitle("Qty: " + number, for: .normal)
                cell.qtyButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
                cell.qty = Int(number)!
                let numberFloat = Float(number)!
                if cell.majorCategory == "Food" && selfLength != nil {
                    let weightOfItem = Float(selfLength!)
                    cell.weight = weightOfItem! * Float(cell.qty)
                }
                else if let weightOfItem = Float(selfWeight!){
                    cell.weight = weightOfItem * numberFloat
                }
                else if let weightOfItem = Float(manufWeight!){
                    cell.weight = weightOfItem * numberFloat
                }
                self.weights[index.row] = cell.weight
                cell.weightLabel.text = String(format: "%.0f", cell.weight) + " g"
                self.updatePackWeight()
            }
            qtyAlert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            qtyAlert.dismiss(animated:true,completion:nil)
        }
        qtyAlert.addAction(cancelAction)
        self.present(qtyAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = false
        if UserDefaults.standard.object(forKey: "packGear") != nil {
            gearIDs = (UserDefaults.standard.object(forKey: "packGear") as! NSArray) as! [String]
        }
        if UserDefaults.standard.object(forKey: "packQtys") != nil {
            qtys = (UserDefaults.standard.object(forKey: "packQtys") as! NSArray) as! [Int]
        }
        if UserDefaults.standard.object(forKey: "weights") != nil {
            weights = (UserDefaults.standard.object(forKey: "weights") as! NSArray) as! [Float]
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        for gearID in gearIDs {
            var fetchedGear: [NSManagedObject] = []
            fetchRequest.predicate = NSPredicate(format: "gearID == %@", gearID)
            do {
                fetchedGear = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch gear. \(error), \(error.userInfo)")
            }
            if !fetchedGear.isEmpty {
                gear.append(fetchedGear[0])
            }
        }
        tableView.reloadData()
        updatePackWeight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gear.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CalculatorTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalculatorTableViewCell else{
            fatalError("The dequeued cell is not an instance of CalculatorTableViewCell")
        }
        if indexPath.row == gear.count {
            cell.majorCategory = ""
            cell.majorCategoryButton.setTitle("Select a category to add a new item", for: .normal)
            cell.majorCategoryButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            cell.categories = []
            cell.category = ""
            cell.gearOptions = []
            cell.gearItem = nil
            cell.qty = 1
            cell.weight = Float(0)
            cell.gearID = ""
            cell.categoryButton.isHidden = true
            cell.itemButton.isHidden = true
            cell.qtyButton.isHidden = true
            cell.weightLabel.isHidden = true
        }
        else {
            let gearItem = gear[indexPath.row]
            cell.gearItem = gearItem
            let qty = qtys[indexPath.row]
            cell.qty = qty
            let details = gearItem.value(forKeyPath: "details") as? String
            let selfWeight = gearItem.value(forKeyPath: "selfWeight") as? String
            let manufWeight = gearItem.value(forKeyPath: "manufWeight") as? String
            let majorCategory = gearItem.value(forKeyPath: "majorCategory") as? String
            var category = gearItem.value(forKeyPath: "category") as? String
            let gearID = gearItem.value(forKeyPath: "gearID") as? String
            let selfLength = gearItem.value(forKeyPath: "selfLength") as? String
            if majorCategory != nil {
                cell.majorCategory = majorCategory!
            }
            if majorCategory == "Ropes" {
                guard let isSingle = gearItem.value(forKeyPath: "isSingle") as? Bool else {
                    print("isSingle not found in stored gear")
                    return cell
                }
                guard let isHalf = gearItem.value(forKeyPath: "isHalf") as? Bool else {
                    print("isHalf not found in stored gear")
                    return cell
                }
                guard let isTwin = gearItem.value(forKeyPath: "isTwin") as? Bool else {
                    print("isTwin not found in stored gear")
                    return cell
                }
                guard let isStatic = gearItem.value(forKeyPath: "isStatic") as? Bool else {
                    print("isStatic not found in stored gear")
                    return cell
                }
                if isSingle == true {
                    category = "Single"
                }
                else if isHalf == true {
                    category = "Half"
                }
                else if isTwin == true {
                    category = "Twin"
                }
                else if isStatic == true {
                    category = "Static"
                }
            }
            if category != nil {
                cell.category = category!
            }
            switch cell.majorCategory {
                case "Skigear":
                    cell.majorCategoryButton.setTitle("Ski Gear", for: .normal)
                case "Sleepgear":
                    cell.majorCategoryButton.setTitle("Sleeping Gear", for: .normal)
                case "Climbing Hardware":
                    cell.majorCategoryButton.setTitle("Hardware", for: .normal)
                case "Food":
                    cell.majorCategoryButton.setTitle("Foods", for: .normal)
                case "Ice":
                    cell.majorCategoryButton.setTitle("Ice Gear", for: .normal)
                case "Cooking":
                    cell.majorCategoryButton.setTitle("Cooking Gear", for: .normal)
                case "Water":
                    cell.majorCategoryButton.setTitle("Water Storage", for: .normal)
                default:
                    cell.majorCategoryButton.setTitle(majorCategory, for: .normal)
            }
            cell.majorCategoryButton.setTitleColor(UIColor.black, for: .normal)
            if category != "" {
                cell.categoryButton.setTitle(category, for: .normal)
                cell.categoryButton.setTitleColor(UIColor.black, for: .normal)
                cell.categoryButton.isHidden = false
            }
            cell.itemButton.setTitle(details, for: .normal)
            cell.itemButton.setTitleColor(UIColor.black, for: .normal)
            cell.qtyButton.setTitle("Qty: " + String(qty), for: .normal)
            cell.qtyButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            if cell.majorCategory == "Food" && selfLength != nil {
                let weightOfItem = Float(selfLength!)
                cell.weight = weightOfItem! * Float(cell.qty)
                cell.weightLabel.textColor = UIColor(red: 0.498, green: 0, blue: 0, alpha: 1)
            }
            else if let weightOfItem = Float(selfWeight!){
                cell.weight = weightOfItem * Float(cell.qty)
                cell.weightLabel.textColor = UIColor.black
            }
            else if let weightOfItem = Float(manufWeight!){
                cell.weight = weightOfItem * Float(cell.qty)
                cell.weightLabel.textColor = UIColor(red: 0.498, green: 0, blue: 0, alpha: 1)
            }
            cell.weightLabel.text = String(format: "%.0f", cell.weight) + " g"
            if gearID != nil {
                cell.gearID = gearID!
            }
            if majorCategory == "Packs" || majorCategory == "Lighting" || majorCategory == "Miscellaneous"  || majorCategory == "Eyewear" || majorCategory == "Helmets" || majorCategory == "Water Storage" {
                cell.gearOptions = self.getGearWithMajorCategory(majorCategory: majorCategory!)
            }
            else if majorCategory == "Ropes" && category != nil {
                cell.gearOptions = self.getRopeWithCategory(category: category!)
            }
            else if category != nil {
                cell.gearOptions = self.getGearWithCategory(category: category!)
            }
            cell.itemButton.isHidden = false
            cell.qtyButton.isHidden = false
            cell.weightLabel.isHidden = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let rowCount = tableView.numberOfRows(inSection: 0)
        let row = indexPath.row + 1
        if row < rowCount {
            return true
        }
        else {
            return false
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gear.remove(at: indexPath.row)
            qtys.remove(at: indexPath.row)
            gearIDs.remove(at: indexPath.row)
            weights.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updatePackWeight()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(gearIDs, forKey: "packGear")
        UserDefaults.standard.set(qtys, forKey: "packQtys")
        UserDefaults.standard.set(weights, forKey: "weights")
    }
    
    func getGearWithMajorCategory(majorCategory: String) -> [NSManagedObject] {
        var gear: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return gear
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        fetchRequest.predicate = NSPredicate(format: "majorCategory == %@", majorCategory)
        do {
            gear = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch CoreData gear. \(error), \(error.userInfo)")
        }
        return gear
    }
    
    func getGearWithCategory(category: String) -> [NSManagedObject] {
        var gear: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return gear
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        do {
            gear = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch CoreData gear. \(error), \(error.userInfo)")
        }
        return gear
    }
    
    func getRopeWithCategory(category: String) -> [NSManagedObject] {
        var gear: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return gear
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        switch category {
        case "Single":
            fetchRequest.predicate = NSPredicate(format: "isSingle == %@", NSNumber(booleanLiteral: true))
        case "Half":
            fetchRequest.predicate = NSPredicate(format: "isHalf == %@", NSNumber(booleanLiteral: true))
        case "Twin":
            fetchRequest.predicate = NSPredicate(format: "isTwin == %@", NSNumber(booleanLiteral: true))
        case "Static":
            fetchRequest.predicate = NSPredicate(format: "isStatic == %@", NSNumber(booleanLiteral: true))
        default:
            return gear
        }
        do {
            gear = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch CoreData gear. \(error), \(error.userInfo)")
        }
        return gear
    }
    
    private func updatePackWeight() {
        var sum = Float(0)
        for weight in weights {
            sum += weight
        }
        self.sumOfWeights = sum
        sumButton.title = "Total weight: " + String(format: "%.0f", sumOfWeights) + " g"
    }
    private func updateEditing() {
        let rowCount = tableView.numberOfRows(inSection: 0)
        for row in 0 ..< rowCount {
            let cell = tableView.cellForRow(at: NSIndexPath(row: row, section: 0) as IndexPath) as! CalculatorTableViewCell
            if cell.gearItem != nil {
                cell.majorCategoryButton.isEnabled = false
                cell.categoryButton.isEnabled = false
                cell.itemButton.isEnabled = false
            }
        }
    }
    
    
}
