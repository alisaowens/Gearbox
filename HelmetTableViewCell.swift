import UIKit

class HelmetTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var helmetDetailsLabel: UILabel!
    @IBOutlet weak var helmetWeightLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


