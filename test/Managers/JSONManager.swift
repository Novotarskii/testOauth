import UIKit
import Foundation

class JSONManager {
    static let shared : JSONManager = JSONManager()
    private let user : UserInfo = UserInfo.shared
    
    
    func transformJSON(jsonObject : Any) {
        if let dictionary = jsonObject as? [String: Any] {
            
            user.bio = getBio(dictionary: dictionary)
            user.email = getEmail(dictionary: dictionary)
            user.avatar = getAvatar(dictionary: dictionary)
            user.blog = getBlog(dictionary: dictionary)
            user.company = getCompany(dictionary: dictionary)
            user.folowers = getFolowers(dictionary: dictionary)
            user.folowing = getFollowing(dictionary: dictionary)
            user.location = getLocation(dictionary: dictionary)
            user.name = getName(dictionary: dictionary)
            user.repos = getPublicRepo(dictionary: dictionary)
            
        }
    }
    
    func getBio(dictionary : [String : Any]) -> String{
        if let bio = dictionary["bio"] as? String {
            return bio
        }
        return ""
    }
    
    func getEmail(dictionary : [String : Any]) -> String{
        if let email = dictionary["email"] as? String {
            return email
        }
        return ""
    }
    
    func getAvatar(dictionary : [String : Any]) -> String{
        if let avatar = dictionary["avatar_url"] as? String {
            return avatar
        }
        return ""
    }
    
    func getBlog(dictionary : [String : Any]) -> String{
        if let blog = dictionary["blog"] as? String {
            return blog
        }
        return ""
    }
    
    func getCompany(dictionary : [String : Any]) -> String{
        if let company = dictionary["company"] as? String {
            return company
        }
        return ""
    }
    
    func getFolowers(dictionary : [String : Any]) -> Int{
        if let folowers = dictionary["followers"] as? Int {
            return folowers
        }
        return 0
    }
    
    func getFollowing (dictionary : [String : Any]) -> Int{
        if let following = dictionary["following"] as? Int {
            return following
        }
        return 0
    }
    
    func getLocation(dictionary : [String : Any]) -> String{
        if let location = dictionary["location"] as? String {
            return location
        }
        return ""
    }
    
    func getName(dictionary : [String : Any]) -> String{
        if let name = dictionary["name"] as? String {
            return name
        }
        return ""
    }
    
    func getPublicRepo(dictionary : [String : Any]) -> Int{
        if let repo = dictionary["public_repos"] as? Int {
            return repo
        }
        return 0
    }
    
}
