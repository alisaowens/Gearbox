import UIKit

class FootwearTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var footwearDetailsLabel: UILabel!
    @IBOutlet weak var footwearWeightLabel: UILabel!
    @IBOutlet weak var footwearSizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

