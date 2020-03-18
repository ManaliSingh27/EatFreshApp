//
//  Utility.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 25/02/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit
import Network

class Utility: NSObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    /// Checks Internet Connectivity
    /// - parameter completion: Completion handler with Bool value for internet connectivity status
    func checkInternetConnectivity(completion : @escaping (Bool) -> Void)
    {
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
        }
        monitor.start(queue: queue)
    }
    
    /// Shows Alert on View Controller
    /// - parameter title: Title of alert to be displayed
    /// - parameter message: Message of alert to be displayed
    /// - parameter vc: View Controller on which alert to be shown
    static func showAlert(title: String, message: String, vc:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            vc.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Activity Indicator
    /// Shows Activity indicator
    /// - parameter view: view on which activity indicator to be added
    /// - parameter activityIndicator: activity indicator instance
    static func showActivityIndicatory(view: UIView , activityIndicator : UIActivityIndicatorView) {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
    }
    
    /// Shows Activity indicator
    /// - parameter view: view on which activity indicator to be added
    /// - parameter activityIndicator: activity indicator instance
    static func removeActivityIndicator(view: UIView, activityIndicator : UIActivityIndicatorView)
    {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()

    }
    
}




