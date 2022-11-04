//
//  UIButton.swift
//
//  Created by Murat ŞENOL on 11.10.2022.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable override var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var capsule: Bool {
        set {
            layer.cornerRadius = self.bounds.size.height / 2.0
        }
        get {
            return layer.cornerRadius == self.bounds.size.height / 2.0 ? true : false
        }
    }
}
