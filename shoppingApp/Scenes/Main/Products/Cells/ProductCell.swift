//
//  ProductCell.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 3.11.2022.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: ProductItem) {
        ivProduct.setImage(withPath: item.productImage)
        labelTitle.text = item.productName
        labelPrice.text = item.productPrice?.currency
    }

}
