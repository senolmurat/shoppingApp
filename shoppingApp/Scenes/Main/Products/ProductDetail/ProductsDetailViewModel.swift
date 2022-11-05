//
//  ProductsDetailViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 4.11.2022.
//

import API
import Foundation
import FirebaseFirestoreSwift

protocol ProductDetailDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didErrorOccurred(_ message: String)
    func didGetProduct(response: ProductsDetailViewModel.FetchProduct.Response)
    func didAddToBasket()
    func didFetchUpdateProductAmount()
    func didCheckProductInBasket(response: ProductsDetailViewModel.FetchToCheckProductInBasket.Response)
}

final class ProductsDetailViewModel {
    
    public enum FetchProduct {
        struct Request {}
        struct Response {
            var product: ProductItem
        }
    }
    public enum FetchAddToBasket {
        struct Request {
            var product: ProductItem
        }
        struct Response {}
    }
    
    public enum FetchProductAmount {
        struct Request {
            var productId: Int
            var amount: Int
        }
        struct Response {}
    }
    
    public enum FetchToCheckProductInBasket {
        struct Request {
            var productId: Int
        }
        struct Response {
            var isProductInBasket: Bool
        }
    }
    
    weak var delegate: ProductDetailDelegate?
    var product: ProductItem?
    
    private(set) var productsResponse: ProductsDetailViewModel.FetchProduct.Response? {
        didSet {
            delegate?.didGetProduct(response: productsResponse!)
        }
    }

    init(){}
    
    func fetchProduct(_ request: ProductsDetailViewModel.FetchProduct.Request) {
        guard let product = product else {
            self.delegate?.didErrorOccurred("Something went wrong. Plesase try again.")
            return
        }
        self.productsResponse = .init(product: product)
    }
    
    func fetchAddToBasket(_ request: ProductsDetailViewModel.FetchAddToBasket.Request) {
        guard let userId = FirebaseManager.currentAuthUser?.uid else {
            self.delegate?.didErrorOccurred("Something went wrong. Current Logged in User does not exists")
            return
        }
        let product = request.product
        let basketRef = FirebaseManager.db.collection("basket").document(userId)
        do {
            try basketRef.collection("basket").document(String(request.product.productId)).setData(from: Product(
                id: product.productId,
                title: product.productName,
                price: product.productPrice,
                description: product.productDescription,
                category: product.productCategory,
                image: product.productImage,
                rating: product.productRating))
            self.delegate?.didAddToBasket()
        } catch let error {
            self.delegate?.didErrorOccurred(error)
        }
    }
    
    func fetchUpdateProductAmount(request: ProductsDetailViewModel.FetchProductAmount.Request) {
        guard let userId = FirebaseManager.currentAuthUser?.uid else {
            self.delegate?.didErrorOccurred("Something went wrong. Current Logged in User does not exists")
            return
        }
        let basketRef = FirebaseManager.db.collection("basket").document(userId)
        let productRef = basketRef.collection("basket").document(String(request.productId))
        productRef.updateData([
            "amount": request.amount
        ]) { error in
            if let error = error {
                self.delegate?.didErrorOccurred(error)
            } else {
                self.delegate?.didFetchUpdateProductAmount()
            }
        }
    }
    
    func fetchToCheckProductInBasket(request: ProductsDetailViewModel.FetchToCheckProductInBasket.Request) {
        guard let userId = FirebaseManager.currentAuthUser?.uid else {
            self.delegate?.didErrorOccurred("Something went wrong. Current Logged in User does not exists")
            return
        }
        let basketRef = FirebaseManager.db.collection("basket").document(userId)
        basketRef.collection("basket").document(String(request.productId)).getDocument { (document, error) in
            if document?.exists ?? false {
                self.delegate?.didCheckProductInBasket(response: .init(isProductInBasket: true))
            } else {
                self.delegate?.didCheckProductInBasket(response: .init(isProductInBasket: false))
            }
        }
        
    }
}
