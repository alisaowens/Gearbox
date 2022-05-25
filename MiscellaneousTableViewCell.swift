import UIKit

class MiscellaneousTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var miscellaneousDetailsLabel: UILabel!
    @IBOutlet weak var miscellaneousWeightLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


