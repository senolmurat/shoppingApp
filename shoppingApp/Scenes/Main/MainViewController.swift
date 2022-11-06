//
//  MainViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit

class MainViewController: UITabBarController {
    
    private var viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        viewModel.delegate = self
        viewModel.fetchBasket()
        
        let productsVC = ProductsViewController()
        productsVC.title = "Products"
        productsVC.view.backgroundColor = .dustyWhite
        
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.view.backgroundColor = .dustyWhite
        
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        profileVC.view.backgroundColor = .dustyWhite
    
        
        let navigationController = UINavigationController(rootViewController: productsVC)
        let navigationController2 = UINavigationController(rootViewController: searchVC)
        let navigationController3 = UINavigationController(rootViewController: profileVC)

        self.viewControllers = [navigationController, navigationController2, navigationController3]
        self.tabBar.tintColor = .themeColor2
        
        guard let items = self.tabBar.items else {
            return
        }
        items[0].image = UIImage(named: "house.fill")
        items[1].image = UIImage(named: "search")
        items[2].image = UIImage(named: "person.fill")
    }
}

extension MainViewController: MainDelegate {
    func didErrorOccurred(_ error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didErrorOccurred(_ message: String) {
        AlertManager.showInfoAlertBox(with: message, errorTitle: "Error", in: self, handler: nil)
    }
    
    func didFetchBasket(response: MainViewModel.FetchBasket.Response) {
        NotificationCenter.default.post(name: Notification.Name("basketCostChanged"), object: response.basketTotal.currency)
    }
    
    
}

extension MainViewController: UITabBarControllerDelegate {
    
}
