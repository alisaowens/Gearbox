import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class CalculatorTableViewCell: UITableViewCell {
    @IBOutlet weak var majorCategoryButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var qtyButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
    
    var majorCategory = ""
    var categories: [String] = []
    var category = ""
    var gearOptions: [NSManagedObject] = []
    var gearItem: NSManagedObject?
    var qty = 1
    var weight = Float(0)
    var gearID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
