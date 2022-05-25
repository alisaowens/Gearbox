import UIKit

class RopeTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var ropeDetailsLabel: UILabel!
    @IBOutlet weak var diameterLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var densityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
