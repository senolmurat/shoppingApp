//
//  SearchViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: ProductCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: ProductCell.getDescribingIdentifier())
        }
    }
    
    private var labelBasketAmount = UILabel()
    private var lastEnteredText: String = ""
    private var isInSearchMode: Bool = false
    private var viewModel = SearchViewModel()
    private var selectedCategory: String = "All"
    private var totalPhotoCount: Int = 0
    private var productList: [ProductItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var categories: [String] = []
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupSearchBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.basketCostChanged(notification:)), name: Notification.Name("basketCostChanged"), object: nil)
        
        viewModel.delegate = self
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
    
    private func setupSearchBar() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search something..."
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .themeColor2
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    @objc private func cartClicked() {
        let basketVC = BasketViewController()
        basketVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(basketVC, animated: true)
    }
    
    @objc func basketCostChanged(notification: Notification) {
        guard let text = notification.object as? String else {return}
        labelBasketAmount.text = text
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
          selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO: safe array access
        let category = viewModel.categories[selectedScope]
        self.selectedCategory = category
        viewModel.fetchSearch(.init(text: searchBar.text ?? "", category: category))
      }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 2 {
            collectionView.showCollectionViewLoadingIndicator()
            lastEnteredText = text
            viewModel.fetchSearch(.init(text: text, category: selectedCategory))
        } else if let text = searchController.searchBar.text, text.count == 0 {
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
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
extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
extension SearchViewController: UICollectionViewDataSource {
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

extension SearchViewController: SearchDelegate {
    
    func didfetchAllCategories() {
        self.navigationItem.searchController?.searchBar.scopeButtonTitles = viewModel.categories
    }
    
    func didErrorOccurred(_ message: String) {
        collectionView.restore()
        AlertManager.showInfoAlertBox(with: message, errorTitle: "Error", in: self, handler: nil)
    }
    
    func didGetSearch(response: SearchViewModel.FetchSearch.Response) {
        collectionView.restore()
        //isInSearchMode = true
        //productList.append(contentsOf: response.items)
        productList = response.items
        if(productList.isEmpty) {
            collectionView.setEmptyMessage("No Result...")
        }
    }
    
    func didErrorOccurred(_ error: Error) {
        collectionView.restore()
        // TODO: pop back to previous page
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
}
