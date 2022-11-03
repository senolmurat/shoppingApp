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
    
    private var viewModel = ProductsViewModel()
    private var productList: [ProductItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navBarItem = UIBarButtonItem()
        navBarItem.title = "22.0"
        navBarItem.image = UIImage(named: "cart")
        navigationItem.rightBarButtonItem = navBarItem
        
        viewModel.delegate = self
        viewModel.fetchProducts(.init())
    }
}

// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: DetailPage for produtc
        /*
        let detailVC = SearchDetailViewController()
        detailVC.photo = photoList[indexPath.row]
        detailVC.providesPresentationContextTransitionStyle = true
        detailVC.definesPresentationContext = true
        //detailVC.modalPresentationStyle = .currentContext
        detailVC.view.backgroundColor = UIColor.shadow
        //navigationController?.pushViewController(detailVC, animated: true)
        self.present(detailVC, animated: true)
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as? ProductCell
        imageCell?.ivProduct.kf.cancelDownloadTask()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat
        columns = 3
        
        let spacing: CGFloat = 4
        let totalHorizontalSpacing = (columns - 1) * spacing
        
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
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didGetProducts(response: ProductsViewModel.FetchProducts.Response) {
        productList = response.items
        collectionView.reloadData()
    }
    
}
