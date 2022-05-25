import UIKit

class CookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cookingDetailsLabel: UILabel!
    @IBOutlet weak var cookingWeightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


