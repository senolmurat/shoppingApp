//
//  ProductsDetailViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 4.11.2022.
//

import Foundation

protocol ProductDetailDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didErrorOccurred(_ message: String)
    func didGetProduct(response: ProductsDetailViewModel.FetchProduct.Response)
}

final class ProductsDetailViewModel {
    
    public enum FetchProduct {
        struct Request {}
        struct Response {
            var product: ProductItem
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
    
    func fetchProduct(_ request: ProductsViewModel.FetchProducts.Request) {
        guard let product = product else {
            self.delegate?.didErrorOccurred("Something went wrong. Plesase try again.")
            return
        }
        self.productsResponse = .init(product: product)
    }
}
