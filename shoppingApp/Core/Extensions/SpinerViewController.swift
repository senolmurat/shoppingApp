//
//  SpiinerViewController.swift
//  cryptoScreen
//
//  Created by Murat ŞENOL on 11.10.2022.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {
    
    override func loadView() {
        var spinner: UIActivityIndicatorView?
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(style: .large)
        } else {
            spinner = UIActivityIndicatorView(style: .whiteLarge)
        }
        guard let spinner = spinner else { return }
        view = UIView()
        view.backgroundColor = UIColor.white

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
