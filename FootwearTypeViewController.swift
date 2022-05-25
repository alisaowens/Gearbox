import UIKit

class FootwearTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueFootwearTableViewController = "FootwearTableViewController"
    
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
    
    @IBAction func skiType(_ sender: Any) {
        tappedType = "Ski Boots"
        performSegue(withIdentifier: SegueFootwearTableViewController, sender: self)
    }
    
    @IBAction func mountainType(_ sender: Any) {
        tappedType = "Mountain Boots"
        performSegue(withIdentifier: SegueFootwearTableViewController, sender: self)
    }
    
    @IBAction func runningtype(_ sender: Any) {
        tappedType = "Trail Shoes"
        performSegue(withIdentifier: SegueFootwearTableViewController, sender: self)
    }
    
    @IBAction func rockType(_ sender: Any) {
        tappedType = "Rock Shoes"
        performSegue(withIdentifier: SegueFootwearTableViewController, sender: self)
    }
    
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Footwear"
        performSegue(withIdentifier: SegueFootwearTableViewController, sender: self)
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
        if segue.identifier == "FootwearTableViewController" {
            guard let footwearTableViewController = segue.destination as? FootwearTableViewController else{fatalError()}
            footwearTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromFootwearTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}


