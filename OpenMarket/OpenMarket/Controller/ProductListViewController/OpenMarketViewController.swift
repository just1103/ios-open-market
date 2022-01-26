//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    // MARK: - Properties
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    let dataSource = OpenMarketDataSource()
    
    private let segmentedControl = LayoutKindSegmentedControl()
    private let activityIndicator = UIActivityIndicatorView()
    private(set) var productListStackView = ProductListStackView()
    private(set) weak var productCollectionView: ProductsCollectionView!
    private(set) var refreshControl = UIRefreshControl()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupViewController()
        setupNavigationBar()
        setupProductListStackView()
        setupCollectionView()
        setupActivityIndicator()
        registerCell()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func reloadDataWithActivityIndicator(at collectionView: ProductsCollectionView?) {
        startActivityIndicator()
        collectionView?.reloadDataCompletion { [weak self] in
            self?.endActivityIndicator()
        }
    }
}

// MARK: - DataSource
extension OpenMarketViewController: OpenMarketDataSourceDelegate {
    private func setupDataSource() {
        dataSource.delegate = self
    }
    
    func openMarketDataSourceDidChangeLayout() {
        let currentScrollRatio: CGFloat = currentScrollRatio()
        
        productCollectionView.fadeOut { _ in
            self.productCollectionView.reloadDataCompletion { [weak self] in
                self?.syncScrollIndicator(with: currentScrollRatio)
                self?.productCollectionView.fadeIn()
            }
        }
    }
    
    func openMarketDataSourceDidSetupProducts() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadDataWithActivityIndicator(at: self?.productCollectionView)
        }
    }
    
    func openMarketDataSourceDidCheckNewProduct() {
        DispatchQueue.main.async { [weak self] in
            self?.productListStackView.showRefreshButton()
        }
    }
}

// MARK: - SegmentControl
extension OpenMarketViewController {
    @objc func toggleViewTypeSegmentedControl(_ sender: UISegmentedControl) {
        dataSource.changeLayoutKind(at: sender.selectedSegmentIndex)
    }
    
    private func currentScrollRatio() -> CGFloat {
        return productCollectionView.contentOffset.y / productCollectionView.contentSize.height
    }
    
    private func syncScrollIndicator(with currentScrollRatio: CGFloat) {
        let nextViewMaxHeight = productCollectionView.contentSize.height
        let offset = CGPoint(x: 0, y: nextViewMaxHeight * currentScrollRatio)
        productCollectionView.setContentOffset(offset, animated: false)
    }
}

// MARK: - NavigationBar, Segmented Control
extension OpenMarketViewController {
    private func setupNavigationBar() {
        segmentedControl.addTarget(self, action: #selector(toggleViewTypeSegmentedControl), for: .valueChanged)
        
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(touchUpAddProductButton))
    }
    
    @objc private func touchUpAddProductButton() {
        let addProductViewController = AddProductViewController()
        navigationController?.pushViewController(addProductViewController, animated: true)
    }
}

// MARK: - ActivityIndicator
extension OpenMarketViewController {
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        startActivityIndicator()
    }
    
    private func startActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
    }
    
    private func endActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
    }
}

// MARK: - CollectionView
extension OpenMarketViewController {
    private func setupProductListStackView() {
        view.addSubview(productListStackView)
        productListStackView.setupConstraints(with: view)
        productListStackView.listRefreshButton.addTarget(self,
                                                         action: #selector(didRefreshed),
                                                         for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        productCollectionView = productListStackView.productCollectionView
        productCollectionView.dataSource = dataSource
        productCollectionView.delegate = self
        setupRefreshControl()
    }
    
    private func registerCell() {
        OpenMarketDataSource.LayoutKind.allCases.forEach {
            productCollectionView.register($0.cellType, forCellWithReuseIdentifier: $0.cellIdentifier)
        }
    }
    
    private func setupRefreshControl() {
        productCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefreshed), for: .valueChanged)
    }
    
    @objc private func didRefreshed() {
        dataSource.setupProducts()
        productListStackView.hideRefreshButton()
        productCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}
