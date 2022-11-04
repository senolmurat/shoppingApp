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
    
    var viewModel = BasketViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
}

// MARK: BasketDelegate
extension BasketViewController: BasketDelegate {
    func didErrorOccurred(_ error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
}

// MARK: UITableViewDelegate
extension BasketViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemCell.getDescribingIdentifier(), for: indexPath) as! BasketItemCell
        cell.configure(item: product)
        return cell
    }
    
}
