//
//  ProductsDetailViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 4.11.2022.
//

import UIKit
import Toast

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
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.productAmountChangedNotification(notification:)), name: Notification.Name("productAmountChangedInBasket"), object: nil)
        self.navigationController?.navigationBar.tintColor = .themeColor2
        
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
        labelStepperCounter.text = Int(stepper.value).description
        
        viewModel.fetchToCheckProductInBasket(request: .init(productId: product.productId))
        addToCartButton.isHidden = false
        stepperStackView.isHidden = true
    }
    
    private func IsProductInBasket(result: Bool) {
        addToCartButton.isHidden = result
        stepperStackView.isHidden = !result
    }
    
    @objc func productAmountChangedNotification(notification: Notification) {
        guard let item = notification.object as? ProductItem else {return}
        if item.productId != self.product?.productId {
            return
        }
        labelStepperCounter.text = item.amountInBasket.description
        self.product?.amountInBasket = item.amountInBasket
    }

    @IBAction func addToCartPressed(_ sender: UIButton) {
        // TODO: add product to basket and show stepper
        guard let product = product else {
            // TODO: pop
            return
        }
        viewModel.fetchAddToBasket(.init(product: product))
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        product?.amountInBasket = Int(sender.value)
        guard let product = product else {return}
        labelStepperCounter.text = Int(sender.value).description
        viewModel.fetchUpdateProductAmount(request: .init(productId: product.productId, amount: Int(sender.value)))
    }
    
}

extension ProductsDetailViewController: ProductDetailDelegate {
    func didCheckProductInBasket(response: ProductsDetailViewModel.FetchToCheckProductInBasket.Response) {
        self.IsProductInBasket(result: response.isProductInBasket)
    }
   
    func didErrorOccurred(_ error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didErrorOccurred(_ message: String) {
        AlertManager.showInfoAlertBox(with: message, errorTitle: "Error", in: self, handler: nil)
    }
    
    func didGetProduct(response: ProductsDetailViewModel.FetchProduct.Response) {
        self.product = response.product
        stepper.value = Double(response.product.amountInBasket)
        setupUI()
    }
    
    func didAddToBasket() {
        self.view.makeToast("Product Added to basket", duration: 3.0, position: .top)
        self.IsProductInBasket(result: true)
        // TODO: show activity indiciator in stack view
        
    }
    
    func didFetchUpdateProductAmount() {
        guard let product = product else {return}
        NotificationCenter.default.post(name: Notification.Name("productAmountChangedInProductDetail"), object: product)
    }
    
}
