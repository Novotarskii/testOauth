
import UIKit
import OAuthSwift

class EditViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveNavItem: UIBarButtonItem!
    @IBOutlet weak var cancelNavItem: UIBarButtonItem!
    
    private let user : UserInfo = UserInfo.shared
    private let network : NetworkManager = NetworkManager.sharedInstance
    private let update : UpdateUser = UpdateUser.shared
    private let oauth : OAuth = OAuth.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib (nibName: "EditHeaderView", bundle: nil), forCellReuseIdentifier: "EditHeader")
        tableView.register(UINib (nibName: "ChangeOtherDataTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeOtherData")
        tableView.register(UINib (nibName: "ChangeBioTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeBio")
        
        if network.reachability.connection != .none {
            didConnect()
        } else {
            didDisconnect()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func cancelNavItemClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveNavItemClick(_ sender: UIBarButtonItem) {
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? ChangeOtherDataTableViewCell {
            if let data = cell.userTextView.text {
                if cell.isNotValidLbl.isHidden {
                    update.blog = data
                } else {
                    return
                }
                
            }
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ChangeOtherDataTableViewCell {
            if let data = cell.userTextView.text {
                update.name = data
            }
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as? ChangeOtherDataTableViewCell {
            if let data = cell.userTextView.text {
                update.company = data
            }
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 3, section: 0)) as? ChangeOtherDataTableViewCell {
            if let data = cell.userTextView.text {
                update.location = data
            }
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 4, section: 0)) as? ChangeBioTableViewCell {
            if let data = cell.bioTextView.text {
                update.bio = data
            }
        }
        if network.reachability.connection != .none {
            oauth.updateProfile(controller: self)
        } else {
            didDisconnect()
        }
        
        
    }
    
    func setLineUnderTableViewCell(height : CGFloat, width : CGFloat) -> CALayer{
        var bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        bottomBorder .frame = CGRect(x: leadingConstrain, y: height, width: width, height: 1)
        return bottomBorder
    }
    
    func setCells(cell : ChangeOtherDataTableViewCell?, indexPath : IndexPath) {
        switch indexPath.item {
        case 0:
            cell?.userDataLbl.text = "nameLbl".localize()
            cell?.userTextView.placeholder = "nickNamePlaceholder".localize()
            cell?.userTextView.text = user.name
            cell?.isNotValidLbl.isHidden = true
            break
        case 1:
            cell?.userDataLbl.text = "blogLbl".localize()
            cell?.userDataLbl.textColor = UIColor.black
            cell?.userTextView.placeholder = "blogPlaceholder".localize()
            cell?.userTextView.text = user.blog //Перевірка на валідність
            //cell?.isNotValidLbl.isHidden = false
            break
        case 2:
            cell?.userDataLbl.text = "companyLbl".localize()
            cell?.userTextView.placeholder = "companyPlaceholder".localize()
            cell?.userTextView.text = user.company
            cell?.isNotValidLbl.isHidden = true
            break
        case 3:
            cell?.userDataLbl.text = "locationLbl".localize()
            cell?.userTextView.placeholder = "cityPlaceholder".localize()
            cell?.userTextView.text = user.location
            cell?.isNotValidLbl.isHidden = true
            break
        default:
            break
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, profileImg : UIImageView){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                profileImg.image = UIImage(data: data)
            }
        }
    }
}

extension EditViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 4 {
            return heightEditTableViewBioCell
        } else if  indexPath.item == 1{
            return heightEditTableViewBlogCell
        } else {
            return 35
        }
        
    }
    
}

extension EditViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countEditTableViewRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countEditTableViewSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeBio", for: indexPath) as? ChangeBioTableViewCell
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell?.bioLbl.text = "bioLbl".localize()
            cell?.bioTextView.text = user.bio
            
            return cell ?? ChangeBioTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeOtherData", for: indexPath) as? ChangeOtherDataTableViewCell
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            setCells(cell: cell, indexPath: indexPath)
            cell?.layer.addSublayer(setLineUnderTableViewCell(height: (cell?.frame.size.height) ?? 1 - 1, width: cell?.frame.size.width ?? 1))
            return cell ?? InfoAboutRepoTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = EditHeaderView.fromNib()
        
        let url = URL(string: user.avatar)!
        downloadImage(from: url, profileImg: cell.profileImg)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightEditTableHeader
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension EditViewController: CheckNetworkState {
    func didConnect() {
        saveNavItem.isEnabled = true
        self.hideActivityIndicator()
    }
    
    func didDisconnect() {
        saveNavItem.isEnabled = false
        self.showActivityIndicator()
    }
}
