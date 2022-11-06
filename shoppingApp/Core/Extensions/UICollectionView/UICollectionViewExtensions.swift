//
//  UICollectionViewExtensions.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 23.06.2022.
//

import Foundation
import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
    
    func showCollectionViewLoadingIndicator() {
        var spinner: UIActivityIndicatorView?
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                spinner = UIActivityIndicatorView(style: .medium)
            } else {
                spinner = UIActivityIndicatorView(style: .white)
            }
            guard let spinner = spinner else { return }
            spinner.color = .themeColor2
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(100))

            self.backgroundView = spinner
        }
    }
}
