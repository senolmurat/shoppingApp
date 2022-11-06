//
//  BasketViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 2.11.2022.
//

import UIKit
import Toast

class BasketViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: BasketItemCell.getNibName(), bundle: nil), forCellReuseIdentifier: BasketItemCell.getDescribingIdentifier())
        }
    }
    @IBOutlet weak var labelTotalAmount: UILabel!
    
    private var basketItems: [ProductItem] = [] {
        didSet {
            setupUI()
            guard let tableView = tableView else {return}
            if basketItems.isEmpty {
                tableView.setEmptyMessage("Your basket is empty...")
            } else {
                tableView.restore()
            }
        }
    }
    var viewModel = BasketViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .themeColor2
        
        title = "Basket"
        viewModel.delegate = self
        tableView.showTableViewLoadingIndicator()
        viewModel.fetchBasket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.productAmountChangedNotification(notification:)), name: Notification.Name("productAmountChangedInProductDetail"), object: nil)
    }
    
    @objc func productAmountChangedNotification(notification: Notification) {
        guard let item = notification.object as? ProductItem else {return}
        if let itemIndex = basketItems.firstIndex(where: { $0.productId == item.productId } ) {
            basketItems[itemIndex].amountInBasket = item.amountInBasket
        } else {
            basketItems.append(item)
        }
        
        //tableView.reloadRows(at: [IndexPath(row: itemIndex, section: 1)], with: .automatic)
        tableView.reloadData()
        setupUI()
    }
    
    private func setupUI() {
        var total: Double = 0
        for product in basketItems {
            total += (product.productPrice ?? 0) * Double(product.amountInBasket)
        }
        labelTotalAmount.text = total.currency
        NotificationCenter.default.post(name: Notification.Name("basketCostChanged"), object: total.currency)
    }
    
    private func deleteProductFromBasket(item: ProductItem?) {
        guard let item = item else {return}
        self.showLoadingIndicator()
        viewModel.fetchDeleteProduct(reqeust: .init(productId: item.productId))
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        AlertManager.showConfirmation(with: "Are you sure you want to confirm the purchase ?", in: self) { action in
            self.showLoadingIndicator()
            self.viewModel.fetchEmptyBasket(reqeust: .init(basket: self.basketItems))
        }
    }
}

// MARK: BasketDelegate
extension BasketViewController: BasketDelegate {
    func didDeleteProduct(response: BasketViewModel.FetchDeleteProduct.Response) {
        self.dismissLoadingIndicator()
        guard let itemIndex = basketItems.firstIndex(where: { $0.productId == response.productId } ) else {return}
        basketItems.remove(at: itemIndex)
        tableView.reloadData()
        setupUI()
        self.view.makeToast("Product removed from basket", duration: 3.0, position: .top)
    }
    
    func didEmptyBasket() {
        self.dismissLoadingIndicator()
        self.basketItems.removeAll()
        tableView.reloadData()
        AlertManager.showInfoAlertBox(with: "Purchase Successfull", errorTitle: "Success", in: self, handler: nil)
    }
    
    func didErrorOccurred(_ message: String) {
        tableView.restore()
        self.dismissLoadingIndicator()
        AlertManager.showInfoAlertBox(with: message, errorTitle: "Error", in: self, handler: nil)
    }
    func didErrorOccurred(_ error: Error) {
        tableView.restore()
        self.dismissLoadingIndicator()
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didFetchBasket(response: BasketViewModel.FetchBasket.Response) {
        tableView.restore()
        guard let basket = response.basket else {
            // TODO: basket is empty
            return
        }
        self.basketItems = basket
        setupUI()
        tableView.reloadData()
    }
    
    func didFetchUpdateProductAmount(response: BasketViewModel.FetchProductAmount.Response) {
        guard let itemIndex = basketItems.firstIndex(where: { $0.productId == response.productId } ) else {return}
        basketItems[itemIndex].amountInBasket = response.amount
        setupUI()
    }
}

// MARK: BasketItemCellDelegate
extension BasketViewController: BasketItemCellDelegate {
    func didStepperValueChanged(value: Int, item: ProductItem) {
        viewModel.fetchUpdateProductAmount(reqeust: .init(productId: item.productId, amount: value))
        NotificationCenter.default.post(name: Notification.Name("productAmountChangedInBasket"), object: item)
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
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteProductFromBasket(item: self?.basketItems[indexPath.row] )
                                            completionHandler(true)
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
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


