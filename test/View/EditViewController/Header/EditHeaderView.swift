

import UIKit

class EditHeaderView: UIView {

    @IBOutlet weak var containerImg: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var changePhotoBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerImg.layer.cornerRadius = containerImg.frame.size.width / 2
        changePhotoBtn.layer.cornerRadius = roundabout
    }
    
    class func fromNib() -> EditHeaderView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditHeaderView
    }
    
    @IBAction func changePhotoBtnTouchUpInside(_ sender: UIButton) {
        
    }
    
}
