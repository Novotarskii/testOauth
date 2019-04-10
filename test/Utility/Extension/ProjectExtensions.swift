import UIKit
import Foundation

extension UIViewController {
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .white)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        activityIndicatorView.color = .black
        activityIndicatorView.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = "withoutInternetITtle".localize()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        
        let fittingSize = titleLabel.sizeThatFits(CGSize(width: 200.0, height: activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRect(x: activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8,
                                  y: activityIndicatorView.frame.origin.y,
                                  width: fittingSize.width,
                                  height: fittingSize.height)
        
        let rect = CGRect(x: (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2,
                          y: (activityIndicatorView.frame.size.height) / 2,
                          width: activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width,
                          height: activityIndicatorView.frame.size.height)
        let titleView = UIView(frame: rect)
        titleView.addSubview(activityIndicatorView)
        titleView.addSubview(titleLabel)
        
        navigationItem.titleView = titleView
    }
    
    func hideActivityIndicator() {
        navigationItem.titleView = nil
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
