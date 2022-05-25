import UIKit

class SkiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skiDetailsLabel: UILabel!
    @IBOutlet weak var skiWeightLabel: UILabel!
    @IBOutlet weak var skiLengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

