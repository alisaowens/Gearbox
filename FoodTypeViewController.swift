import UIKit

class FoodTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueFoodTableViewController = "FoodTableViewController"
    
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
    
    @IBAction func barType(_ sender: Any) {
        tappedType = "Bars"
        performSegue(withIdentifier: SegueFoodTableViewController, sender: sender)
    }
    
    @IBAction func gelType(_ sender: Any) {
        tappedType = "Gels"
        performSegue(withIdentifier: SegueFoodTableViewController, sender: sender)
    }
    
    @IBAction func powderType(_ sender: Any) {
        tappedType = "Powders"
        performSegue(withIdentifier: SegueFoodTableViewController, sender: sender)
    }
    
    @IBAction func freezeDriedType(_ sender: Any) {
        tappedType = "Freeze-dried"
        performSegue(withIdentifier: SegueFoodTableViewController, sender: sender)
    }
    
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Food"
        performSegue(withIdentifier: SegueFoodTableViewController, sender: sender)
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
        if segue.identifier == "FoodTableViewController" {
            guard let foodTableViewController = segue.destination as? FoodTableViewController else{fatalError()}
            foodTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromFoodTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}


