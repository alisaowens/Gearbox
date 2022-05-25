import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class FoodTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var filterType = ""
    var gear: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
         
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
        fetchRequest.predicate = NSPredicate(format: "category == %@", filterType)
        let sortDescriptor = NSSortDescriptor(key: "update", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            gear = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch CoreData gear. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = true
        navigationItem.title = filterType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gear.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FoodTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FoodTableViewCell else{
            fatalError("The dequeued cell is not an instance of FoodTableViewCell")
        }
        
        //Fetches the appropriate food for the data source layout
        let gearItem = gear[indexPath.row]
        let details = gearItem.value(forKeyPath: "details") as? String
        let servingSize = gearItem.value(forKeyPath: "selfLength") as? String
        let calories = gearItem.value(forKeyPath: "selfWeight") as? String
        cell.foodDetailsLabel.text = details
        cell.caloriesPerGramLabel.textColor = UIColor(red: 0.498, green: 0, blue: 0, alpha: 1)
        if servingSize != nil {
            if let servingSizeValue = Double(servingSize!){
                if let caloriesValue = Double(calories!){
                    cell.caloriesPerGramLabel.text = String(format:"%.1f", caloriesValue / servingSizeValue) + " cal/g"}
            }
            else {
                cell.caloriesPerGramLabel.text = "cal/g"
            }
        }
        else {
            cell.caloriesPerGramLabel.text = "cal/g"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let selectedGear = gear[indexPath.row]
            deleteGearFromCloud(gear: selectedGear)
            managedContext.delete(selectedGear)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gear")
            fetchRequest.predicate = NSPredicate(format: "category == %@", filterType)
            let sortDescriptor = NSSortDescriptor(key: "update", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                gear = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch CoreData gear after deletion. \(error), \(error.userInfo)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddFood":
            guard let foodViewController = segue.destination as? FoodViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            foodViewController.category = filterType
            foodViewController.isEdit = false
        case "ShowDetail":
            guard let foodDetailViewController = segue.destination as? FoodViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedFoodCell = sender as? FoodTableViewCell else {
                fatalError("Unexpected sender")
            }
            guard let indexPath = tableView.indexPath(for: selectedFoodCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            if self.isEditing == false{
                let selectedItem = gear[indexPath.row]
                let gearID = selectedItem.value(forKeyPath: "gearID") as? String
                foodDetailViewController.gear = selectedItem
                foodDetailViewController.gearID = gearID
            }
            foodDetailViewController.category = filterType
            foodDetailViewController.isEdit = true
        default:
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !self.isEditing
    }
    
    //MARK: Actions
    @IBAction func unwindFromFood(sender: UIStoryboardSegue){
        return
    }
    
    //MARK: Private methods
    
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
    }
}

