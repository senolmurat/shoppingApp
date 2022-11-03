//
//  UIViewExtensions.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 3.11.2022.
//

import Foundation
import UIKit

@IBDesignable extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}

