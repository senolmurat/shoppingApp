//
//  ProductsDetailViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 4.11.2022.
//

import UIKit

class ProductsDetailViewController: UIViewController {

    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var stepperStackView: UIStackView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var labelStepperCounter: UILabel!
    
    var viewModel = ProductsDetailViewModel()
    private var product: ProductItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Product Detail"
        viewModel.delegate = self
        viewModel.fetchProduct(.init())
    }
    
    private func setupUI(){
        guard let product = product else {
            // TODO: pop
            return
        }
        ivProduct.setImage(withPath: product.productImage)
        labelPrice.text = product.productPrice?.currency
        labelTitle.text = product.productName
        labelDescription.text = product.productDescription
        
        // TODO: check if product exsist in basket
        addToCartButton.isHidden = false
        stepperStackView.isHidden = true
    }

    @IBAction func addToCartPressed(_ sender: UIButton) {
        // TODO: add product to basket and show stepper
    }
}

extension ProductsDetailViewController: ProductDetailDelegate {
    func didErrorOccurred(_ error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didErrorOccurred(_ message: String) {
        AlertManager.showInfoAlertBox(with: message, errorTitle: "Error", in: self, handler: nil)
    }
    
    func didGetProduct(response: ProductsDetailViewModel.FetchProduct.Response) {
        self.product = response.product
        setupUI()
    }
}
