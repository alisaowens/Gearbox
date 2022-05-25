import UIKit

class FoodTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var foodDetailsLabel: UILabel!
    @IBOutlet weak var caloriesPerGramLabel: UILabel!
    @IBOutlet weak var fatPerGramLabel: UILabel!
    @IBOutlet weak var carbsPerGramLabel: UILabel!
    @IBOutlet weak var proteinPerGramLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
