//
//  ProfileViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit


class ProfileViewController: UIViewController {

    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var logoutStackView: UIStackView!
    
    private var viewModel = ProfileViewModel()
    private var user: UserItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        viewModel.delegate = self
        viewModel.fetchProfile(.init())
    }
    
    private func setup() {
        title = "Product Detail"
        
        let navBarItem = UIBarButtonItem()
        navBarItem.title = "22.0"
        navBarItem.image = UIImage(named: "cart")
        navBarItem.action = #selector(self.cartClicked)
        navigationItem.rightBarButtonItem = navBarItem
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(logoutStackViewClicked))
        logoutStackView.addGestureRecognizer(tap)
        logoutStackView.isUserInteractionEnabled = true
    }
    
    private func setupUI() {
        guard let user = user else {
            return
        }
        labelEmail.text = user.userEmail
        labelUserName.text = user.userName
    }
    
    @objc private func logoutStackViewClicked() {
        AlertManager.showConfirmation(with: "Are you sure you want to log out ?", in: self) { action in
            self.viewModel.fetchLogout()
        }
    }
    
    @objc private func cartClicked() {
        let basketVC = BasketViewController()
        basketVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(basketVC, animated: true)
    }

}

extension ProfileViewController: ProfileDelegate {
    
    func didErrorOccurred(_ error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didErrorOccurred(_ message: String) {
        AlertManager.showInfoAlertBox(with: message, errorTitle: "Error", in: self, handler: nil)
    }
    
    func didGetProfile(response: ProfileViewModel.FetchProfile.Response) {
        self.user = response.user
        setupUI()
    }
    
    func didLogout(response: ProfileViewModel.FetchLogout.Response) {
        let viewController = AuthViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        self.present(viewController, animated: true)
    }
    
}
