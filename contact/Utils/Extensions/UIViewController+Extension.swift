//
//  UIViewController+Extension.swift
//  contact
//
//  Created by Pinkesh Gjr on 04/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static var storyboardIdentifier: String {
      return String(describing: self)
    }
    
    //MARK:- Activity
    func showIndicator(view: UIView) {
        let container: UIView = UIView()
        container.tag = 555
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        container.frame = view.bounds
        container.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3022527825)
        
        activityIndicator.frame = CGRect (x: 0, y: 0, width: 80, height: 80)
        activityIndicator.style = .large
        activityIndicator.center = container.center
        activityIndicator.hidesWhenStopped = true
        
        DispatchQueue.main.async {
            container.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            view.addSubview(container)
        }
    }
    
    func hideIndicator(view: UIView) {
        DispatchQueue.main.async {
            view.viewWithTag(555)?.removeFromSuperview()
        }
    }
    
    func showAlerControllerWith(title: String?, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
