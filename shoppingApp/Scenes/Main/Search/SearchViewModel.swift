//
//  SearchViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import Foundation
import API

protocol SearchDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didErrorOccurred(_ message: String)
    func didGetSearch(response: SearchViewModel.FetchSearch.Response)
    func didfetchAllCategories()
}

final class SearchViewModel {
    
    public enum FetchSearch {
        struct Request {
            let text: String
            let category: String
        }
        struct Response {
            var items: [ProductItem]
        }
    }
    
    public enum FetchCategory {
        struct Request {
            let text: String
            let category: String
        }
        struct Response {
            var items: [ProductItem]
        }
    }
    
    weak var delegate: SearchDelegate?
    
    private var products: [ProductItem] = []
    var categories: [String] = []
    
    private(set) var searchResponse: SearchViewModel.FetchSearch.Response? {
        didSet {
            delegate?.didGetSearch(response: searchResponse!)
        }
    }

    init(){
        fetchAllCategories()
        fetchAllProducts()
    }
    
    private func fetchAllCategories() {
        provider.request(.getAllCategories) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccurred(error)
            case .success(let response):
                do {
                    self.categories.append("All")
                    //get all categories
                    let categories = try JSONDecoder().decode([String].self, from: response.data)
                    self.categories.append(contentsOf: categories)
                    self.delegate?.didfetchAllCategories()
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
    
    private func fetchAllProducts() {
        provider.request(.getAllProducts) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccurred(error)
            case .success(let response):
                do {
                    //get all products
                    let items = try JSONDecoder().decode([Product].self, from: response.data)
                    self.products = items
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
    
    func fetchSearch(_ request: SearchViewModel.FetchSearch.Request) {
        if request.category == "All" {
            if request.text.isEmpty {
                self.searchResponse = .init(items: self.products)
                return
            } else {
                self.searchResponse = .init(items: self.products.filter( { $0.productName?.contains(request.text) ?? false }))
                return
            }
        }
        if request.text.isEmpty {
            self.searchResponse = .init(items: self.products.filter( { $0.productCategory == request.category }))
        } else {
            self.searchResponse = .init(items: self.products.filter( { ($0.productName?.contains(request.text) ?? false) && $0.productCategory == request.category }))
        }
    }
    
}
