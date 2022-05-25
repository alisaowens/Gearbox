import UIKit

class WaterTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var waterDetailsLabel: UILabel!
    @IBOutlet weak var waterWeightLabel: UILabel!
    @IBOutlet weak var waterCapacityLabel: UILabel!
    @IBOutlet weak var waterDensityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


