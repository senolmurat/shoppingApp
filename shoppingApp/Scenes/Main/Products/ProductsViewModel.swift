//
//  ProductsViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import Foundation
import API

protocol ProductItem {
    var productId: Int? {get}
    var productName: String? {get}
    var productPrice: Double? {get}
    var productCategory: String? {get}
    var productDescription: String? {get}
    var productImage: String? {get}
    var productRating: Rating? {get}
}

extension Product: ProductItem {
    var productCategory: String? {
        category
    }
    
    var productRating: Rating? {
        rating
    }
    
    var productId: Int? {
        id
    }
    
    var productName: String? {
        title
    }
    
    var productPrice: Double? {
        price
    }
    
    var productDescription: String? {
        description
    }
    
    var productImage: String? {
        image
    }
}

protocol ProductsDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didGetProducts(response: ProductsViewModel.FetchProducts.Response)
}

final class ProductsViewModel {
    
    public enum FetchProducts {
        struct Request {}
        struct Response {
            var items: [ProductItem]
        }
    }
    weak var delegate: ProductsDelegate?
    
    private(set) var productsResponse: ProductsViewModel.FetchProducts.Response? {
        didSet {
            delegate?.didGetProducts(response: productsResponse!)
        }
    }

    init(){}
    
    func fetchProducts(_ request: ProductsViewModel.FetchProducts.Request) {
        provider.request(.getAllProducts) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccurred(error)
            case .success(let response):
                do {
                    let items = try JSONDecoder().decode([Product].self, from: response.data)
                    self.productsResponse = .init(items: items)
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
}

