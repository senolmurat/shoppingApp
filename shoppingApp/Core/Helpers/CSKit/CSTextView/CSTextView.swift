//
//  CSTextView.swift
//  Ceksat
//
//  Created by Pazarama iOS Bootcamp on 22.10.2022.
//

import UIKit

@objc
protocol CSTextViewDelegate: AnyObject {
    @objc optional func textView(_ view: CSTextView, textFieldDidBeginEditing textField: UITextField)
}

@IBDesignable
class CSTextView: CSView {
    
    weak var delegate: CSTextViewDelegate?
    
    @IBInspectable
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    @IBInspectable
    var isSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    @IBInspectable
    var error: String? {
        didSet {
            if let error = error {
                errorLabel.text = error
                errorLabel.isHidden = false
            } else {
                errorLabel.isHidden = true
                errorLabel.text = nil
            }
        }
    }
    
    @IBInspectable
    var isEditingEnable: Bool = true
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func commonInit() {
        super.commonInit()
        textField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension CSTextView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textView?(self, textFieldDidBeginEditing: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isEditingEnable
    }
}
