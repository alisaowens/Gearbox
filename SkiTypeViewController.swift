import UIKit

class SkiTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueSkiTableViewController = "SkiTableViewController"
    
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
        tappedType = "Skis"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    @IBAction func skinType(_ sender: Any) {
        tappedType = "Skins"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    @IBAction func poleType(_ sender: Any) {
        tappedType = "Poles"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    
    @IBAction func cramponType(_ sender: Any) {
        tappedType = "Ski Crampons"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    @IBAction func bindingType(_ sender: Any) {
        tappedType = "Bindings"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    @IBAction func shovelType(_ sender: Any) {
        tappedType = "Shovels"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    @IBAction func probeType(_ sender: Any) {
        tappedType = "Probes"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    @IBAction func transceiverType(_ sender: Any) {
        tappedType = "Transceivers"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
    }
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Ski Gear"
        performSegue(withIdentifier: SegueSkiTableViewController, sender: self)
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
        if segue.identifier == "SkiTableViewController" {
            guard let skiTableViewController = segue.destination as? SkiTableViewController else{fatalError()}
            skiTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromSkiTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}






