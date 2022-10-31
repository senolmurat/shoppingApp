//
//  ViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 31.10.2022.
//

import UIKit

class LaunchViewController: UIViewController {

    private let appImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "appIcon")
        return imageView
    }()
    
    private let spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.addSubview(appImageView)
        view.addSubview(spinner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        appImageView.center = view.center
        spinner.center = CGPoint(x: appImageView.center.x, y: appImageView.center.y + (appImageView.frame.height / 2) + 32)
        
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.spinner.stopAnimating()
            let authVC = AuthViewController()
            authVC.modalTransitionStyle = .crossDissolve
            authVC.modalPresentationStyle = .fullScreen
            self.present(authVC, animated: true)
        }
       
    }

}

