import UIKit

class MiscellaneousTableViewController: UITableViewController {
    
    //MARK: Properties
    var gearItems = [Gear]()
    var itemsToDisplay = [Gear]()
    
    @IBAction func sumButton(_ sender: Any) {
        setEditing(true, animated: true)
        sumButton.title = "Sum: 0 g"
    }
    
    @IBAction func cancelSum(_ sender: Any) {
        setEditing(false, animated: true)
        sumButton.title = "Sum Weights"
        sumOfWeights = Float(0)
        cancelSumButton.title = ""
    }
    
    var sumOfWeights = Float(0)
    
    @IBOutlet weak var sumButton: UIBarButtonItem!
    @IBOutlet weak var cancelSumButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = false
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = true
        cancelSumButton.title = ""
        
        //Load saved general
        if let savedGear = loadGear() {
            gearItems += savedGear
        }
        filterGear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MiscellaneousTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MiscellaneousTableViewCell else{
            fatalError("The dequeued cell is not an instance of MiscellaneousTableViewCell")
        }
        
        //Fetches the appropriate general for the data source layout
        let general = itemsToDisplay[indexPath.row]
        cell.generalDetailsLabel.text = general.details
        if general.selfWeight != "" {
            cell.generalWeightLabel.text = general.selfWeight! + " g"}
        else if general.manufWeight != "" {cell.generalWeightLabel.text = general.manufWeight! + " g"
            cell.generalWeightLabel.textColor = UIColor(red: 0.498, green: 0, blue: 0, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generalToSum = itemsToDisplay[indexPath.row]
        if self.isEditing{
            if let weightOfMiscellaneousToSum = Float(generalToSum.selfWeight!){
                addWeight(weight: weightOfMiscellaneousToSum)}
            else if let weightOfMiscellaneousToSum = Float(generalToSum.manufWeight!){
                addWeight(weight: weightOfMiscellaneousToSum)}
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let generalToSubtract = itemsToDisplay[indexPath.row]
        if self.isEditing{
            if let weightOfMiscellaneousToSubtract = Float(generalToSubtract.selfWeight!){
                subtractWeight(weight: weightOfMiscellaneousToSubtract)}
            else if let weightOfMiscellaneousToSubtract = Float(generalToSubtract.manufWeight!){
                subtractWeight(weight: weightOfMiscellaneousToSubtract)}
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemsToDisplay.remove(at: indexPath.row)
            saveGear()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddMiscellaneous":
            return
        case "ShowDetail":
            guard let generalDetailViewController = segue.destination as? MiscellaneousViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMiscellaneousCell = sender as? MiscellaneousTableViewCell else {
                fatalError("Unexpected sender")
            }
            guard let indexPath = tableView.indexPath(for: selectedMiscellaneousCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            if self.isEditing == false{
                let selectedMiscellaneous = itemsToDisplay[indexPath.row]
                generalDetailViewController.gear = selectedMiscellaneous
            }
        default:
            fatalError("Unexpected Segue Identifier")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !self.isEditing
    }
    
    
    //MARK: Actions
    @IBAction func unwindFromMiscellaneous(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? MiscellaneousViewController, let general = sourceViewController.gear {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing general.
                itemsToDisplay[selectedIndexPath.row] = general
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                //Add a new general.
                gearItems.insert(general, at: 0)
                filterGear()
                tableView.reloadData()
            }
            //Save the general.
            saveGear()
        }
    }
    
    //MARK: Private methods
    
    private func saveGear(){
        gearItems = itemsToDisplay + gearItems.filter{$0.majorCategory != "Miscellaneous"}
        NSKeyedArchiver.archiveRootObject(gearItems, toFile: Gear.ArchiveURL.path)
    }
    private func loadGear() -> [Gear]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Gear.ArchiveURL.path) as? [Gear]
    }
    
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
        cancelSumButton.title = "Done"
    }
    
    private func addWeight(weight: Float) {
        sumOfWeights = sumOfWeights + weight
        sumButton.title = "Sum: " + String(sumOfWeights) + " g"
    }
    
    private func subtractWeight(weight: Float) {
        sumOfWeights = sumOfWeights - weight
        sumButton.title = "Sum: " + String(sumOfWeights) + " g"
    }
    
    func filterGear() {
        itemsToDisplay = gearItems.filter{$0.majorCategory == "Miscellaneous"}
    }
}


