
import UIKit

class ChangeOtherDataTableViewCell: UITableViewCell {

    @IBOutlet weak var isNotValidLbl: UILabel!
    @IBOutlet weak var userTextView: UITextField!
    @IBOutlet weak var userDataLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension ChangeOtherDataTableViewCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if userDataLbl.text == "blogLbl".localize() {
            if str.isValidURL {
                isNotValidLbl.isHidden = true
                return true
            }else {
                isNotValidLbl.isHidden = false
                return true
            }
        }
        return true
    
    }
    
}
