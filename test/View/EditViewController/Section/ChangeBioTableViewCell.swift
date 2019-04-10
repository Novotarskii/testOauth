

import UIKit

class ChangeBioTableViewCell: UITableViewCell {

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
