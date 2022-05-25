import UIKit

class CookingTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueCookingTableViewController = "CookingTableViewController"
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelButton(_ sender: Any) {
        if stackView.isHidden == true {
            UIView.animate(withDuration: 0.1){
                self.stackView.isHidden = false
            }
            cancelButton.setImage(UIImage(named: "Cancel"), for: .normal)
        }
        else {
            UIView.animate(withDuration: 0.1){
                self.stackView.isHidden = true
            }
            cancelButton.setImage(UIImage(named: "Hamburger"), for: .normal)
        }
    }
    
    @IBAction func stoveType(_ sender: Any) {
        tappedType = "Stoves"
        performSegue(withIdentifier: SegueCookingTableViewController, sender: self)
    }
    
    @IBAction func potType(_ sender: Any) {
        tappedType = "Pots"
        performSegue(withIdentifier: SegueCookingTableViewController, sender: self)
    }
    
    @IBAction func fuelType(_ sender: Any) {
        tappedType = "Fuel"
        performSegue(withIdentifier: SegueCookingTableViewController, sender: self)
    }
    
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Cooking Gear"
        performSegue(withIdentifier: SegueCookingTableViewController, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "CookingTableViewController" {
            guard let cookingTableViewController = segue.destination as? CookingTableViewController else{fatalError()}
            cookingTableViewController.filterType = tappedType!
        }
    }
    @IBAction func unwindFromCookingTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}





