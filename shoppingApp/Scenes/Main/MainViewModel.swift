//
//  MainViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import Foundation
import API

protocol MainDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didErrorOccurred(_ message: String)
    func didFetchBasket(response: MainViewModel.FetchBasket.Response)
}

final class MainViewModel {
    public enum FetchBasket {
        struct Request {}
        struct Response {
            var basketTotal: Double
        }
    }
    
    weak var delegate: MainDelegate?
    
    private(set) var basketResponse: MainViewModel.FetchBasket.Response? {
        didSet {
            delegate?.didFetchBasket(response: basketResponse!)
        }
    }
    
    init(){}
    
    func fetchBasket() {
        guard let userId = FirebaseManager.currentAuthUser?.uid else {
            self.delegate?.didErrorOccurred("Something went wrong. Current Logged in User does not exists")
            return
        }
        
        var total: Double = 0
        
        let basketRef = FirebaseManager.db.collection("basket").document(userId)
        basketRef.collection("basket").getDocuments { (querySnapshot, err) in
            if let err = err {
                self.delegate?.didErrorOccurred(err)
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let product = try document.data(as: Product.self)
                        total += (product.productPrice ?? 0) * Double(product.amountInBasket)
                    } catch _ {
                        continue
                    }
                }
                self.delegate?.didFetchBasket(response: .init(basketTotal: total))
            }
        }
    }
}
