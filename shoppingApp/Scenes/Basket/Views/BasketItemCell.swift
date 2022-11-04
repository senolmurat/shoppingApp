//
//  BasketItemCell.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 2.11.2022.
//

import UIKit

class BasketItemCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(item: ProductItem) {
        
    }
    
}
