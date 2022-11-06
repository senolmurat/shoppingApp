//
//  OnboardingViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let pageWidth: CGFloat = UIScreen.main.bounds.width
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var prevButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    private var lastTrailingContraint = NSLayoutConstraint()
    
    var currentPageNumber: Int = .zero {
        didSet {
            if currentPageNumber == onboardingViews.count - 1 {
                nextButton.setTitle("Finish", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
            
            if currentPageNumber == .zero {
                prevButton.isHidden = true
            } else {
                prevButton.isHidden = false
            }
            
            pageControl.currentPage = currentPageNumber
            updateScrollViewContentOffset(with: currentPageNumber)
        }
    }
    
    var onboardingViews = [OnboardingView]() {
        didSet {
            let numberOfPages = onboardingViews.count
            NSLayoutConstraint.deactivate([lastTrailingContraint])
            
                    
            scrollView.contentSize.width = CGFloat(numberOfPages) * pageWidth
            
            pageControl.numberOfPages = numberOfPages
            
            guard let onboardingView = onboardingViews.last else {
                fatalError("OnboardingView not found.")
            }
            
            contentView.addSubview(onboardingView)
            onboardingView.translatesAutoresizingMaskIntoConstraints = false
           
            if onboardingViews.count == 1 {
                NSLayoutConstraint.activate([
                    onboardingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    onboardingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    onboardingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    onboardingView.widthAnchor.constraint(equalToConstant: pageWidth)
                ])
            } else {
                lastTrailingContraint = onboardingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                NSLayoutConstraint.activate([
                    onboardingView.leadingAnchor.constraint(equalTo: onboardingViews[numberOfPages - 2].trailingAnchor),
                    onboardingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    onboardingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    onboardingView.widthAnchor.constraint(equalToConstant: pageWidth),
                    lastTrailingContraint
                ])
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let signUpOnboardingView = OnboardingView()
        signUpOnboardingView.image = UIImage(named: "signUpScreen")
        signUpOnboardingView.text = "You can sign up with your email and password. After signing up you can sign in with the credentials you provided"
        onboardingViews.append(signUpOnboardingView)
        
        let productsScreenView = OnboardingView()
        productsScreenView.image = UIImage(named: "productsScreen")
        productsScreenView.text = "All products will be listed here. You can click on one of them to go to its detail page or you can click on cart icon on top right to go to your basket."
        onboardingViews.append(productsScreenView)
        
        let productDetailScreenView = OnboardingView()
        productDetailScreenView.image = UIImage(named: "productDetail")
        productDetailScreenView.text = "You can see the product details in detail page. You can add this item to your basket by clicking \"Add To Cart\" button."
        onboardingViews.append(productDetailScreenView)
        
        let productDetail2ScreenView = OnboardingView()
        productDetail2ScreenView.image = UIImage(named: "productDetail2")
        productDetail2ScreenView.text = "After that a stepper will show up and with that you can adjust the quantity of the product how ever you want."
        onboardingViews.append(productDetail2ScreenView)
        
        let basketScreenView = OnboardingView()
        basketScreenView.image = UIImage(named: "basketScreen")
        basketScreenView.text = "You can change the quantity of products in your basket with steppers. You also click on a product to go to its detail page from here as well. Click on \"Confirm Purchase\" to finish shopping."
        onboardingViews.append(basketScreenView)
        
        let basketScreenDeleteProductView = OnboardingView()
        basketScreenDeleteProductView.image = UIImage(named: "productsScreenDelete")
        basketScreenDeleteProductView.text = "You can delete products from your basket by fully swiping from right to left or by clicking \"Delete\" after swiping slightly."
        onboardingViews.append(basketScreenDeleteProductView)
        
        let profileScreenView = OnboardingView()
        profileScreenView.image = UIImage(named: "profile")
        profileScreenView.text = "You can see your personal information here and log out from the session."
        onboardingViews.append(profileScreenView)
        
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        if currentPageNumber < onboardingViews.count - 1 {
            currentPageNumber += 1
        } else {
            goToAuth()
        }
    }
    
    @IBAction func didTapPrevButton(_ sender: UIButton) {
        if currentPageNumber > 0 {
            currentPageNumber -= 1
        }
    }
    
    @IBAction func didTapSkipButton(_ sender: UIButton) {
        goToAuth()
    }
    
    @IBAction func didPageControlValueChanged(_ sender: UIPageControl) {
        updateScrollViewContentOffset(with: sender.currentPage)
    }
    
    private func updateScrollViewContentOffset(with pageNumber: Int) {
        let contentOffset = CGPoint(x: pageWidth * CGFloat(pageNumber), y: .zero)
        scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    private func goToAuth() {
        //navigationController?.pushViewController(AuthViewController(), animated: true)
        var authVC = AuthViewController()
        authVC.modalPresentationStyle = .fullScreen
        authVC.modalTransitionStyle = .crossDissolve
        self.present(authVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        currentPageNumber = currentPage
    }
}

