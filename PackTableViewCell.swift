import UIKit

class PackTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var packDetailsLabel: UILabel!
    @IBOutlet weak var packWeightLabel: UILabel!
    @IBOutlet weak var packCapacityLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


