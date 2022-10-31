//
//  ErrorManager.swift
//  
//
//  Created by Murat ŞENOL on 16.05.2022.
//

import Foundation
import UIKit

struct AlertManager{

    static func showInfoAlertBox(for error: NSError , in controller: UIViewController , handler: ((UIAlertAction) -> Void)? ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showInfoAlertBox(with message: String , errorTitle: String, in controller: UIViewController , handler: ((UIAlertAction) -> Void)? ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showConfirmation(with message: String , title: String = "Confirm", in controller: UIViewController , handler: ((UIAlertAction) -> Void)? ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { action in
                //do nothing
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: handler))
            controller.present(alert, animated: true, completion: nil)
        }
    }

}
