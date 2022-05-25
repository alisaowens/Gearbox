import UIKit

class IceTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueIceTableViewController = "IceTableViewController"
    
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
    
    @IBAction func axType(_ sender: Any) {
        tappedType = "Ice Axes"
        performSegue(withIdentifier: SegueIceTableViewController, sender: self)
    }
    
    @IBAction func cramponType(_ sender: Any) {
        tappedType = "Crampons"
        performSegue(withIdentifier: SegueIceTableViewController, sender: self)
    }
    
    @IBAction func leashType(_ sender: Any) {
        tappedType = "Leashes"
        performSegue(withIdentifier: SegueIceTableViewController, sender: self)
    }
    
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Ice Gear"
        performSegue(withIdentifier: SegueIceTableViewController, sender: self)
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
        if segue.identifier == "IceTableViewController" {
            guard let iceTableViewController = segue.destination as? IceTableViewController else{fatalError()}
            iceTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromIceTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}




