//
//  MainViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let productsVC = ProductsViewController()
        productsVC.title = "Products"
        productsVC.view.backgroundColor = .dustyWhite
        
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.view.backgroundColor = .dustyWhite
        
        let profileVC = SearchViewController()
        profileVC.title = "Profile"
        profileVC.view.backgroundColor = .dustyWhite
    
        
        let navigationController = UINavigationController(rootViewController: productsVC)
        let navigationController2 = UINavigationController(rootViewController: searchVC)
        let navigationController3 = UINavigationController(rootViewController: profileVC)

        self.viewControllers = [navigationController, navigationController2, navigationController3]
        
        guard let items = self.tabBar.items else {
            return
        }
        items[0].image = UIImage(named: "house.fill")
        items[1].image = UIImage(named: "search")
        items[2].image = UIImage(named: "person.fill")
    }
}

extension MainViewController: UITabBarControllerDelegate {
    
}
