import UIKit

class ClothingTypeViewController: UIViewController {
    
    var tappedType: String?
    let SegueClothingTableViewController = "ClothingTableViewController"
    
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
    
    @IBAction func hatType(_ sender: Any) {
        tappedType = "Hats & Balaclavas"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func topBaselayerType(_ sender: Any) {
        tappedType = "Tops - Baselayer"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func topInsulationType(_ sender: Any) {
        tappedType = "Tops - Insulation"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func topShellType(_ sender: Any) {
        tappedType = "Tops - Shell"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func bottomBaselayerType(_ sender: Any) {
        tappedType = "Bottoms - Baselayer"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func bottomInsulationType(_ sender: Any) {
        tappedType = "Bottoms - Insulation"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func bottomShellType(_ sender: Any) {
        tappedType = "Bottoms - Shell"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func sockType(_ sender: Any) {
        tappedType = "Socks"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func gloveType(_ sender: Any) {
        tappedType = "Gloves"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func gaiterType(_ sender: Any) {
        tappedType = "Gaiters"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
    }
    
    @IBAction func otherType(_ sender: Any) {
        tappedType = "Other Clothing"
        performSegue(withIdentifier: SegueClothingTableViewController, sender: self)
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
        if segue.identifier == "ClothingTableViewController" {
            guard let clothingTableViewController = segue.destination as? ClothingTableViewController else{fatalError()}
            clothingTableViewController.filterType = tappedType!
        }
    }
    
    @IBAction func unwindFromClothingTable(sender: UIStoryboardSegue){
        self.navigationController?.isToolbarHidden = true
        return
    }
}



