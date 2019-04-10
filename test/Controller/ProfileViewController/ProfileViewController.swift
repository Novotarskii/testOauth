
import UIKit
import OAuthSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutNavItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let oauth : OAuth = OAuth.shared
    var oauthswift: OAuthSwift?
    
    private let user : UserInfo = UserInfo.shared
    private let network : NetworkManager = NetworkManager.sharedInstance
    
    var webV: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oauthswift = oauth.getOauthSwift()
        
        tableView.register(UINib (nibName: "InfoAboutRepoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoAboutRepo")
        tableView.register(UINib (nibName: "PrivaceInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivaceInfo")
        tableView.register(UINib (nibName: "ProfileHeaderView", bundle: nil), forCellReuseIdentifier: "Profile")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.delegate = self
        
        if network.reachability.connection != .none {
            didConnect()
        } else {
            didDisconnect()
        }
        
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func logoutNavItemClick(_ sender: UIBarButtonItem) {
        cleanUserDefault()
        logoutFromGithub()
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    func cleanUserDefault() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    func logoutFromGithub(){
        
        if let url = URL(string: "https://github.com/logout") {
            UIApplication.shared.open(url, options: [:])
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
    
    func setFirstSectionRows(cell : PrivaceInfoTableViewCell?, indexPath : IndexPath) {
        switch indexPath.item {
        case 0:
            cell?.privacyInfoLbl.text = user.email
            break
        case 1:
            cell?.privacyInfoLbl.text = user.blog
            break
        case 2:
            cell?.privacyInfoLbl.text = user.company
            break
        case 3:
            cell?.privacyInfoLbl.text = user.location
            break
        default:
            break
        }
    }
    
    func setSecondSectionRows(cell : InfoAboutRepoTableViewCell?, indexPath : IndexPath) {
        switch indexPath.item {
        case 0:
            cell?.InfoAboutRepoLbl.text = "repoLbl".localize()
            
            if user.repos != 0 {
                cell?.countLbl.text = String(user.repos)
                cell?.countView.isHidden = false
            } else {
                cell?.countView.isHidden = true
            }
            break
        case 1:
            cell?.InfoAboutRepoLbl.text = "starsLbl".localize()
            cell?.countView.isHidden = true
            break
        case 2:
            cell?.InfoAboutRepoLbl.text = "folowersLbl".localize()
            
            if user.folowers != 0 {
                cell?.countLbl.text = String(user.folowers)
                cell?.countView.isHidden = false
            }else {
                cell?.countView.isHidden = true
            }
            break
        case 3:
            cell?.InfoAboutRepoLbl.text = "folowingLbl".localize()
            
            if user.folowing != 0 {
                cell?.countLbl.text = String(user.folowing)
                cell?.countView.isHidden = false
            }else {
                cell?.countView.isHidden = true
            }
            break
        default:
            break
        }
    }
    
    func setSectionHeader(cell : ProfileHeaderView) {
        
        if let endOfSentence = user.name.index(of: " ") {
            let firstName = user.name[...endOfSentence]
            cell.firstNameLbl.text = String(firstName)
        } else {
            let firstName = user.name
            cell.firstNameLbl.text = String(firstName)
        }
        
        
        if let url = URL(string: user.avatar) {
            downloadImage(from: url, profileImg: cell.profileImg)
        }
        

        
        cell.fullNameLbl.text = user.name
        cell.bioLbl.text = user.bio
    }
    
    func setLineUnderTableViewCell(height : CGFloat, width : CGFloat) -> CALayer{
        var bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        bottomBorder .frame = CGRect(x: leadingConstrain, y: height, width: width, height: 1)
        return bottomBorder
    }
}
    


extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightProfileTableViewCell
    }
    
}

extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countProfleTableViewRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countProfleTableViewSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivaceInfo", for: indexPath) as? PrivaceInfoTableViewCell
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            //cell?.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
            setFirstSectionRows(cell: cell, indexPath: indexPath)
            return cell ?? PrivaceInfoTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoAboutRepo", for: indexPath) as? InfoAboutRepoTableViewCell
            cell?.selectionStyle = UITableViewCell.SelectionStyle.default
            setSecondSectionRows(cell: cell, indexPath: indexPath)
            cell?.layer.addSublayer(setLineUnderTableViewCell(height: (cell?.frame.size.height) ?? 1 - 1, width: cell?.frame.size.width ?? 1))
            return cell ?? InfoAboutRepoTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = ProfileHeaderView.fromNib()
            setSectionHeader(cell: cell)
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return heightProfileTableHeader
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension ProfileViewController: CheckNetworkState {
    func didConnect() {
        logoutNavItem.isEnabled = true
        self.hideActivityIndicator()
    }
    
    func didDisconnect() {
        logoutNavItem.isEnabled = false
        self.showActivityIndicator()
    }
    
    
}
