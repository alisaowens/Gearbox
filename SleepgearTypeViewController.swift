import UIKit

class SleepgearTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueSleepgearTableViewController = "SleepgearTableViewController"
    
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
    
    @IBAction func tentType(_ sender: Any) {
        tappedType = "Tents"
        performSegue(withIdentifier: SegueSleepgearTableViewController, sender: self)
    }
    
    @IBAction func bivvyType(_ sender: Any) {
        tappedType = "Bivy Sacks & Tarps"
        performSegue(withIdentifier: SegueSleepgearTableViewController, sender: self)
    }
    
    @IBAction func bagType(_ sender: Any) {
        tappedType = "Sleeping Bags"
        performSegue(withIdentifier: SegueSleepgearTableViewController, sender: self)
    }
    
    @IBAction func padType(_ sender: Any) {
        tappedType = "Sleeping Pads"
        performSegue(withIdentifier: SegueSleepgearTableViewController, sender: self)
    }
    
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Sleeping Gear"
        performSegue(withIdentifier: SegueSleepgearTableViewController, sender: self)
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
        if segue.identifier == "SleepgearTableViewController" {
            guard let sleepgearTableViewController = segue.destination as? SleepgearTableViewController else{fatalError()}
            sleepgearTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromSleepgearTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}



