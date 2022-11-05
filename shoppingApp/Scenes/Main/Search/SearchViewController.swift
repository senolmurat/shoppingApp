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

        let navBarItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(self.cartClicked))
        self.navigationItem.rightBarButtonItem = navBarItem
    }
    
    @objc private func cartClicked() {
        let basketVC = BasketViewController()
        basketVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(basketVC, animated: true)
    }
}
