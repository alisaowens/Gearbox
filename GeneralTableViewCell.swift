import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var generalDetailsLabel: UILabel!
    @IBOutlet weak var generalWeightLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


