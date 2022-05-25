import UIKit

class ElectronicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var electronicDetailsLabel: UILabel!
    @IBOutlet weak var electronicWeightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
