import UIKit

class HardwareTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueHardwareTableViewController = "HardwareTableViewController"
    
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
    
    @IBAction func lockerType(_ sender: Any) {
        tappedType = "Locking Carabiners"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    
    @IBAction func nonLockerType(_ sender: Any) {
        tappedType = "Non-locking Carabiners"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func slingType(_ sender: Any) {
        tappedType = "Slings & Quickdraws"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func chockType(_ sender: Any) {
        tappedType = "Chocks"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func camType(_ sender: Any) {
        tappedType = "Cams"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func pitonType(_ sender: Any) {
        tappedType = "Pitons"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func iceType(_ sender: Any) {
        tappedType = "Ice Screws"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func otherProtectionType(_ sender: Any) {
        tappedType = "Other Protection"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func harnessType(_ sender: Any) {
        tappedType = "Harnesses"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func belayType(_ sender: Any) {
        tappedType = "Belay & Rappel"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func ascenderType(_ sender: Any) {
        tappedType = "Ascenders & Pulleys"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func aidType(_ sender: Any) {
        tappedType = "Aid Gear"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
    }
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Hardware"
        performSegue(withIdentifier: SegueHardwareTableViewController, sender: self)
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
        if segue.identifier == "HardwareTableViewController" {
            guard let hardwareTableViewController = segue.destination as? HardwareTableViewController else{fatalError()}
            hardwareTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromHardwareTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}




