import UIKit

class HardwareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hardwareDetailsLabel: UILabel!
    @IBOutlet weak var hardwareWeightLabel: UILabel!
    @IBOutlet weak var hardwareLengthLabel: UILabel!
    @IBOutlet weak var hardwareDensityLabel: UILabel!
    
    @IBOutlet weak var camConstraint: NSLayoutConstraint!
    @IBOutlet weak var camConstraint2: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
