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

    private var labelBasketAmount = UILabel()
    private var viewModel = ProfileViewModel()
    private var user: UserItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        viewModel.delegate = self
        viewModel.fetchProfile(.init())
    }
    
    private func setup() {
        
        setupNavBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.basketCostChanged(notification:)), name: Notification.Name("basketCostChanged"), object: nil)
        
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
    private func setupNavBar() {
        let cartImage = UIImageView(image: UIImage(named: "cart"))
        cartImage.tintColor = .themeColor2
        cartImage.isUserInteractionEnabled = false
        
        labelBasketAmount.text = ""
        labelBasketAmount.textColor = .themeColor2
        labelBasketAmount.numberOfLines = 1;
        labelBasketAmount.textAlignment = .right;
        labelBasketAmount.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
        labelBasketAmount.sizeToFit()
        let stackView = UIStackView(arrangedSubviews: [cartImage, labelBasketAmount])
        stackView.spacing = 4
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cartClicked))
        stackView.addGestureRecognizer(tap)
        stackView.isUserInteractionEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
        self.navigationController?.navigationBar.tintColor = .themeColor2
    }
    
    @objc private func logoutStackViewClicked() {
        AlertManager.showConfirmation(with: "Are you sure you want to log out ?", in: self) { action in
            self.viewModel.fetchLogout()
        }
    }
    
    @objc func basketCostChanged(notification: Notification) {
        guard let text = notification.object as? String else {return}
        labelBasketAmount.text = text
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
