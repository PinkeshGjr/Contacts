//
//  UIView+Extension.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    static var reuseIdentifier: String {
      return String(describing: self)
    }
    
    func roundedView() {
      layer.cornerRadius = frame.size.height / 2
      layer.masksToBounds = true
    }
    
    func circularView(isBorderless: Bool = true, borderWidth: CGFloat = 2, borderColor: CGColor = UIColor.white.cgColor) {
      layer.cornerRadius = frame.size.height / 2
      layer.masksToBounds = true
      if isBorderless {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
      }
    }
    
    func applyBorder(color: UIColor, width: CGFloat = 1) {
      layer.borderWidth = width
      layer.borderColor = color.cgColor
    }
    
    func applyCornerRadius(radius: CGFloat = 15.0) {
      layoutIfNeeded()
      layer.cornerRadius = radius
      layer.masksToBounds = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
    }
}
