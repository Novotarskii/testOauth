
import UIKit
import OAuthSwift

class SignInViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewAuth: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    private let network : NetworkManager = NetworkManager.sharedInstance
    var oauthswift: OAuthSwift?
    let oauth : OAuth = OAuth.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.oauthswift = oauth.getOauthSwift()
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        loginBtn.layer.cornerRadius = roundabout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            loginBtn.isEnabled = false
            viewAuth.isHidden = false
            activityIndicator.startAnimating()
            
            if network.reachability.connection != .none {
                oauth.autgorizeWithToken(oauthswift: oauthswift as? OAuth2Swift, token: token, controller: self)
            } else {
                didDisconnect()
            }
            
        }
        
        network.delegate = self
        
        if network.userOnline() {
            self.didConnect()
        } else {
            self.didDisconnect()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        loginBtn.isEnabled = true
        viewAuth.isHidden = true
        activityIndicator.stopAnimating()
    }

    @IBAction func loginBtnTouchUpInside(_ sender: UIButton) {
        viewAuth.isHidden = false
        activityIndicator.startAnimating()
        
        oauth.authorizeWithoutToken(oauthswift: self.oauthswift as? OAuth2Swift, controller: self)
    }
    
}

extension SignInViewController: CheckNetworkState {
    func didConnect() {
        loginBtn.isEnabled = true
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            oauth.autgorizeWithToken(oauthswift: oauthswift as? OAuth2Swift, token: token, controller: self)
        }
        
        self.hideActivityIndicator()
    }
    
    func didDisconnect() {
        loginBtn.isEnabled = false
        self.showActivityIndicator()
    }
    
    
}

