//
//  ProductsViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: ProductCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: ProductCell.getDescribingIdentifier())
        }
    }
    
    private var labelBasketAmount = UILabel()
    private var viewModel = ProductsViewModel()
    private var productList: [ProductItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.basketCostChanged(notification:)), name: Notification.Name("basketCostChanged"), object: nil)
        
        setupNavBar()
        
        viewModel.delegate = self
        collectionView.showCollectionViewLoadingIndicator()
        viewModel.fetchProducts(.init())
    }
    
    private func setupNavBar() {
        let cartImage = UIImageView(image: UIImage(named: "cart"))
        cartImage.tintColor = .themeColor2
        cartImage.isUserInteractionEnabled = false
        
        labelBasketAmount.text = ""
        labelBasketAmount.textColor = .themeColor2
        labelBasketAmount.numberOfLines = 1;
        labelBasketAmount.textAlignment = .right;
        labelBasketAmount.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
        labelBasketAmount.sizeToFit()
        let stackView = UIStackView(arrangedSubviews: [cartImage, labelBasketAmount])
        stackView.spacing = 4
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cartClicked))
        stackView.addGestureRecognizer(tap)
        stackView.isUserInteractionEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
        self.navigationController?.navigationBar.tintColor = .themeColor2
    }
    
    @objc func basketCostChanged(notification: Notification) {
        guard let text = notification.object as? String else {return}
        labelBasketAmount.text = text
    }
    
    @objc private func cartClicked() {
        let basketVC = BasketViewController()
        basketVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(basketVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = ProductsDetailViewController()
        detailVC.viewModel.product = productList[indexPath.row]
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as? ProductCell
        imageCell?.ivProduct.kf.cancelDownloadTask()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 3
        let spacing: CGFloat = 4
        let totalHorizontalSpacing = (columns + 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.8)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = productList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.getDescribingIdentifier(), for: indexPath) as! ProductCell
        cell.configure(item: product)
        return cell
    }
    
    
}

extension ProductsViewController: ProductsDelegate {
    func didErrorOccurred(_ error: Error) {
        collectionView.restore()
        // TODO: pop back to previous page
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didGetProducts(response: ProductsViewModel.FetchProducts.Response) {
        collectionView.restore()
        productList = response.items
        collectionView.reloadData()
    }
    
}
