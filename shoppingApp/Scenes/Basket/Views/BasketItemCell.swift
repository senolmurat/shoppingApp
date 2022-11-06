//
//  BasketItemCell.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 2.11.2022.
//

import UIKit

protocol BasketItemCellDelegate: AnyObject {
    func didStepperValueChanged(value: Int, item: ProductItem)
    func didErrorOccurred(_ error: Error)
}

class BasketItemCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    
    var delegate: BasketItemCellDelegate?
    private var product: ProductItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(item: ProductItem) {
        self.product = item
        labelName.text = item.productName
        labelPrice.text = item.productPrice?.currency
        labelCategory.text = item.productCategory?.capitalized
        stepper.value = Double(item.amountInBasket)
        labelQuantity.text = Int(stepper.value).description
        
        ivProduct.setImage(withPath: item.productImage)
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        self.product?.amountInBasket = Int(stepper.value)
        guard let product = self.product else {return}
        let stepper = sender as! UIStepper
        labelQuantity.text = Int(stepper.value).description
        
        self.delegate?.didStepperValueChanged(value: Int(stepper.value), item: product)
    }
}
