//
//  Double+Extensions.swift
//  cryptoScreen
//
//  Created by Murat ŞENOL on 11.10.2022.
//

import Foundation

extension Double {
    var isInt: Bool {
        return floor(self) == self
    }
    
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 4
        formatter.locale = Locale(identifier: "tr_TR")

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
    
    var description: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 4

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
    
}
