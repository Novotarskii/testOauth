//
//  ProfileHeaderView.swift
//  KMM-iOS
//
//  Created by Мак Мини on 12.11.2018.
//  Copyright © 2018 Lampa. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var containerForImg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerForImg.layer.cornerRadius = containerForImg.frame.size.width / 2
    }
    
    class func fromNib() -> ProfileHeaderView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileHeaderView
    }
}
