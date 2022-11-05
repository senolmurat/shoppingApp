//
//  BasketViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 2.11.2022.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: BasketItemCell.getNibName(), bundle: nil), forCellReuseIdentifier: BasketItemCell.getDescribingIdentifier())
        }
    }
    @IBOutlet weak var labelTotalAmount: UILabel!
    
    private var basketItems: [ProductItem] = []
    var viewModel = BasketViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Basket"
        viewModel.delegate = self
        viewModel.fetchBasket()
    }
    
    private func setupUI() {
        var total: Double = 0
        for product in basketItems {
            total += (product.productPrice ?? 0) * Double(product.amountInBasket ?? 0)
        }
        labelTotalAmount.text = total.currency
    }
}

// MARK: BasketDelegate
extension BasketViewController: BasketDelegate {

    
    func didErrorOccurred(_ message: String) {
        AlertManager.showInfoAlertBox(with: message, errorTitle: "Error", in: self, handler: nil)
    }
    func didErrorOccurred(_ error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didFetchBasket(response: BasketViewModel.FetchBasket.Response) {
        guard let basket = response.basket else {
            // TODO: basket is empty
            return
        }
        self.basketItems = basket
        tableView.reloadData()
    }
    
    func didFetchUpdateProductAmount(response: BasketViewModel.FetchProductAmount.Response) {
        print("success")
    }
}

// MARK: BasketItemCellDelegate
extension BasketViewController: BasketItemCellDelegate {
    func didStepperValueChanged(value: Int, item: ProductItem) {
        viewModel.fetchUpdateProductAmount(reqeust: .init(productId: item.productId, amount: value))
    }
}

// MARK: UITableViewDelegate
extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ProductsDetailViewController()
        detailVC.viewModel.product = basketItems[indexPath.row]
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let productCell = cell as? BasketItemCell
        productCell?.ivProduct.kf.cancelDownloadTask()
    }
}

// MARK: UITableViewDataSource
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        basketItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = basketItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemCell.getDescribingIdentifier(), for: indexPath) as! BasketItemCell
        cell.configure(item: product)
        cell.delegate = self
        return cell
    }
    
}


