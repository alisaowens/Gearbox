import UIKit

class ClothingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clothingDetailsLabel: UILabel!
    @IBOutlet weak var clothingWeightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
