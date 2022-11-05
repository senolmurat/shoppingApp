//
//  SearchViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navBarItem = UIBarButtonItem()
        navBarItem.title = "22.0"
        navBarItem.image = UIImage(named: "cart")
        navBarItem.action = #selector(self.cartClicked)
        navigationItem.rightBarButtonItem = navBarItem
    }
    
    @objc private func cartClicked() {
        let basketVC = BasketViewController()
        basketVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(basketVC, animated: true)
    }
}
