
import Foundation
import OAuthSwift
import Alamofire

class OAuth {
    
    static let shared = OAuth()
    private let json : JSONManager = JSONManager.shared
    private let user : UserInfo = UserInfo.shared
    private let update : UpdateUser = UpdateUser.shared
    
    func getOauthSwift() -> OAuthSwift{
        let oauthswift = OAuth2Swift(
            consumerKey:    "303039c2738cbcb182a4",
            consumerSecret: "34e84e0528dabe7abe90044ca154a1429965fe0f",
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "code"
        )
        
        return oauthswift
    }
    
    func authorizeWithoutToken(oauthswift : OAuth2Swift?, controller : UIViewController) {
        
        guard let oauth = oauthswift else {
            return
        }
        
        let _ = oauth.authorize(
            withCallbackURL: URL(string: "test-swift://oauth/authorize")!,
            scope: "user", state:"GITHUB",
            success: { credential, response, parameters in
                self.autgorizeWithToken(oauthswift: oauth, token: credential.oauthToken, controller: controller)
        },
            failure: { error in
                print(error.localizedDescription)
        }
        )
    }
    
    
    
    func autgorizeWithToken(oauthswift : OAuth2Swift?, token : String, controller : UIViewController) {
        
        guard let _ = oauthswift else {
            return
        }
        
        oauthswift?.client.get("https://api.github.com/user?access_token=" + token,
                              success: { response in
                                UserDefaults.standard.set(token, forKey: "token")
                                
                                let dataString = try! response.jsonObject()
                                self.json.transformJSON(jsonObject: dataString)
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                                controller.present(resultViewController ?? TabBarViewController(), animated: false, completion: nil)
                                
        },
                              failure: { error in
                                print(error.localizedDescription)
        }
        )
    }
    
    func updateProfile(controller : UIViewController) {
        
        do {
            
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            
            var request = URLRequest(url: URL(string: "https://api.github.com/user?access_token=" + token)!)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let params = ["name" : update.name, "blog" : update.blog, "company" : update.company, "location" : update.location, "bio": update.bio]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: params)
            
            Alamofire.request(request)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print(responseString)
                        }
                    case .success(let responseObject):
                        self.json.transformJSON(jsonObject: responseObject)
                        controller.navigationController?.popViewController(animated: true)
                    }
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
}


