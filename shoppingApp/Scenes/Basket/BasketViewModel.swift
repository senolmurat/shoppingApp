//
//  BasketViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 2.11.2022.
//

import Foundation
import API

protocol BasketDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
}


final class BasketViewModel {
    init() {}
    
    weak var delegate: BasketDelegate?
    
    var items: [Product]?
    
    func fetchBasket() {
        
    }
}
