import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class SleepgearTableViewController: UITableViewController {
    
    //MARK: Properties
    
    @IBAction func sumButton(_ sender: Any) {
        setEditing(true, animated: true)
        if sumButton.title == "Sum Weights" {
            sumButton.title = "Sum: 0.0 g"
        }
        cancelSumButton.title = "Done"
    }
    
    @IBAction func cancelSumButton(_ sender: Any) {
        setEditing(false, animated: true)
        sumButton.title = "Sum Weights"
        sumOfWeights = Float(0)
        cancelSumButton.title = " "
    }
    
    var sumOfWeights = Float(0)
    
    @IBOutlet weak var sumButton: UIBarButtonItem!
    @IBOutlet weak var cancelSumButton: UIBarButtonItem!
    
    var filterType = ""
    var gear: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancelSumButton.title = ""
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
        let cellIdentifier = "SleepgearTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SleepgearTableViewCell else{
            fatalError("The dequeued cell is not an instance of SleepgearTableViewCell")
        }
        
        //Fetches the appropriate sleepgear for the data source layout
        let gearItem = gear[indexPath.row]
        let details = gearItem.value(forKeyPath: "details") as? String
        let selfWeight = gearItem.value(forKeyPath: "selfWeight") as? String
        let manufWeight = gearItem.value(forKeyPath: "manufWeight") as? String
        cell.sleepgearDetailsLabel.text = details
        if selfWeight != "" && selfWeight != nil {
            cell.sleepgearWeightLabel.text = selfWeight! + " g"
            cell.sleepgearWeightLabel.textColor = UIColor.black
        }
        else if manufWeight != "" && manufWeight != nil {
            cell.sleepgearWeightLabel.text = manufWeight! + " g"
            cell.sleepgearWeightLabel.textColor = UIColor(red: 0.498, green: 0, blue: 0, alpha: 1)
        }
        else {
            cell.sleepgearWeightLabel.text = "g"
            cell.sleepgearWeightLabel.textColor = UIColor.black
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isEditing{
            let itemToSum = gear[indexPath.row]
            let selfWeight = itemToSum.value(forKeyPath: "selfWeight") as? String
            let manufWeight = itemToSum.value(forKeyPath: "manufWeight") as? String
            if let weightOfItemToSum = Float(selfWeight!){
                addWeight(weight: weightOfItemToSum)}
            else if let weightOfItemToSum = Float(manufWeight!){
                addWeight(weight: weightOfItemToSum)}
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.isEditing{
            let itemToSubtract = gear[indexPath.row]
            let selfWeight = itemToSubtract.value(forKeyPath: "selfWeight") as? String
            let manufWeight = itemToSubtract.value(forKeyPath: "manufWeight") as? String
            if let weightOfItemToSubtract = Float(selfWeight!){
                subtractWeight(weight: weightOfItemToSubtract)}
            else if let weightOfItemToSubtract = Float(manufWeight!){
                subtractWeight(weight: weightOfItemToSubtract)}
        }
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
        case "AddSleepgear":
            guard let sleepgearViewController = segue.destination as? SleepgearViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            sleepgearViewController.category = filterType
            sleepgearViewController.isEdit = false
        case "ShowDetail":
            guard let detailViewController = segue.destination as? SleepgearViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedSleepgearCell = sender as? SleepgearTableViewCell else {
                fatalError("Unexpected sender")
            }
            guard let indexPath = tableView.indexPath(for: selectedSleepgearCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            if self.isEditing == false{
                let selectedItem = gear[indexPath.row]
                let gearID = selectedItem.value(forKeyPath: "gearID") as? String
                detailViewController.gear = selectedItem
                detailViewController.gearID = gearID
            }
            detailViewController.category = filterType
            detailViewController.isEdit = true
        default:
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !self.isEditing
    }
    
    
    //MARK: Actions
    @IBAction func unwindFromSleepgear(sender: UIStoryboardSegue){
        return
    }
    
    //MARK: Private methods
    
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
    }
    
    private func addWeight(weight: Float) {
        sumOfWeights = sumOfWeights + weight
        sumButton.title = "Sum: " + String(sumOfWeights) + " g"
    }
    
    private func subtractWeight(weight: Float) {
        sumOfWeights = sumOfWeights - weight
        sumButton.title = "Sum: " + String(sumOfWeights) + " g"
    }
}
