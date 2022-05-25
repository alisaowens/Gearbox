import UIKit

class RopeTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueRopeTableViewController = "RopeTableViewController"
    
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
    
    @IBAction func singleType(_ sender: Any) {
        tappedType = "Single"
        performSegue(withIdentifier: SegueRopeTableViewController, sender: sender)
    }
    
    @IBAction func halfType(_ sender: Any) {
        tappedType = "Half"
        performSegue(withIdentifier: SegueRopeTableViewController, sender: sender)
    }
    
    @IBAction func twinType(_ sender: Any) {
        tappedType = "Twin"
        performSegue(withIdentifier: SegueRopeTableViewController, sender: self)
    }
    
    @IBAction func staticType(_ sender: Any) {
        tappedType = "Static"
        performSegue(withIdentifier: SegueRopeTableViewController, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "RopeTableViewController" {
            guard let ropeTableViewController = segue.destination as? RopeTableViewController else{fatalError()}
            ropeTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromRopeTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
        }
}
