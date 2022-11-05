//
//  BasketViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 2.11.2022.
//

import Foundation
import API
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol BasketDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didErrorOccurred(_ message: String)
    func didFetchBasket(response: BasketViewModel.FetchBasket.Response)
    func didFetchUpdateProductAmount(response: BasketViewModel.FetchProductAmount.Response)
}


final class BasketViewModel {
    public enum FetchBasket {
        struct Request {}
        struct Response {
            var basket: [ProductItem]?
        }
    }
    
    public enum FetchProductAmount {
        struct Request {
            var productId: Int
            var amount: Int
        }
        struct Response {
            var isSuccesfull: Bool
        }
    }
    
    weak var delegate: BasketDelegate?
    
    private(set) var basketResponse: BasketViewModel.FetchBasket.Response? {
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
        
        var items: [ProductItem] = []
        
        let basketRef = FirebaseManager.db.collection("basket").document(userId)
        basketRef.collection("basket").getDocuments { (querySnapshot, err) in
            if let err = err {
                self.delegate?.didErrorOccurred(err)
            } else {
                for document in querySnapshot!.documents {
                    do {
                        try items.append(document.data(as: Product.self))
                    } catch _ {
                        continue
                    }
                }
                self.delegate?.didFetchBasket(response: .init(basket: items))
            }
        }
    }
    
    func fetchUpdateProductAmount(reqeust: BasketViewModel.FetchProductAmount.Request) {
        guard let userId = FirebaseManager.currentAuthUser?.uid else {
            self.delegate?.didErrorOccurred("Something went wrong. Current Logged in User does not exists")
            return
        }
        let basketRef = FirebaseManager.db.collection("basket").document(userId)
        let productRef = basketRef.collection("basket").document(String(reqeust.productId))
        productRef.updateData([
            "amount": reqeust.amount
        ]) { error in
            if let error = error {
                self.delegate?.didErrorOccurred(error)
            } else {
                self.delegate?.didFetchUpdateProductAmount(response: .init(isSuccesfull: true))
            }
        }
    }
}
