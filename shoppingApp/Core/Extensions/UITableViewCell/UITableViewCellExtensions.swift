//
//  UITableViewCellExtensions.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 23.06.2022.
//

import Foundation
import UIKit

extension UITableViewCell{
    static func getDescribingIdentifier() -> String{
        return String(describing: self)
    }
    
    /// Function to get nibName of a Cell Class , SHOULD ONLY BE USED IF CELL IDENTIFIER AND CELL NIB NAME IS EXACTLY SAME !
    /// - Returns: String representing Cell nibName
    static func getNibName() -> String{
        return getDescribingIdentifier()
    }
}
