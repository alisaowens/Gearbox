import UIKit

class LightingTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var lightingDetailsLabel: UILabel!
    @IBOutlet weak var lightingWeightLabel: UILabel!
    @IBOutlet weak var lightingLumensLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


