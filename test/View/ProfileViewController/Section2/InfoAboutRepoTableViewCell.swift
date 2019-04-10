
import UIKit

class InfoAboutRepoTableViewCell: UITableViewCell {

    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var InfoAboutRepoLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        countView.layer.cornerRadius = roundabout
        countView.layer.masksToBounds = true

    }
    
}
