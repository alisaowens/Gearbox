import UIKit

class ElectronicTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueElectronicTableViewController = "ElectronicTableViewController"
    
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
    
    @IBAction func cameraType(_ sender: Any) {
        tappedType = "Cameras"
        performSegue(withIdentifier: SegueElectronicTableViewController, sender: self)
    }
    
    @IBAction func phoneType(_ sender: Any) {
        tappedType = "Phones"
        performSegue(withIdentifier: SegueElectronicTableViewController, sender: self)
    }
    
    @IBAction func gpsType(_ sender: Any) {
        tappedType = "GPS"
        performSegue(withIdentifier: SegueElectronicTableViewController, sender: self)
    }
    
    @IBAction func watchType(_ sender: Any) {
        tappedType = "Watches"
        performSegue(withIdentifier: SegueElectronicTableViewController, sender: self)
    }
    
    @IBAction func batteryType(_ sender: Any) {
        tappedType = "Batteries"
        performSegue(withIdentifier: SegueElectronicTableViewController, sender: self)
    }
    
    @IBAction func musicType(_ sender: Any) {
        tappedType = "Music Players"
        performSegue(withIdentifier: SegueElectronicTableViewController, sender: self)
    }
    
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Electronics"
        performSegue(withIdentifier: SegueElectronicTableViewController, sender: self)
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
        if segue.identifier == "ElectronicTableViewController" {
            guard let electronicTableViewController = segue.destination as? ElectronicTableViewController else{fatalError()}
            electronicTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromElectronicTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}



