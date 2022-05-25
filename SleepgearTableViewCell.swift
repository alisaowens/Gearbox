import UIKit

class SleepgearTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sleepgearDetailsLabel: UILabel!
    @IBOutlet weak var sleepgearWeightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
