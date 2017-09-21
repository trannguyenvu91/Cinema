//
//  MDListMovieViewController.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit

fileprivate struct MDListMovieUIConstant {
    let cellRatio = 1.5
    let cellInterSpace = 10.0
    let numberOfCellsPerLine: Double = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    let screenWidth = Double(UIScreen.main.bounds.size.width)
    let loadMoreBottomThresshold: CGFloat = 100.0
    let movieSegueID = "MDMovieViewController"
}

class MDListMovieViewController: UIViewController {
    
    var loadingIndicator = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = MDListMovieViewModel()
    var collectionBinder: MDCollectionViewDataSource!
    fileprivate let uiConstant = MDListMovieUIConstant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didFinishLoading = finishLoading
        bindCollectionView()
        setupRefresh()
        viewModel.refreshMovies()
    }
    
    func bindCollectionView() {
        collectionBinder = MDCollectionViewDataSource(collectionView: collectionView, owner: self, dataProvider: viewModel.movieProvider, cellID: "Cell")
    }
    
    func setupRefresh() {
        collectionView.addSubview(loadingIndicator)
        loadingIndicator.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refresh() {
        loadingIndicator.beginRefreshing()
        viewModel.refreshMovies()
    }

    func finishLoading() {
        if loadingIndicator.isRefreshing {
            loadingIndicator.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == uiConstant.movieSegueID,
            let movieVC = segue.destination as? MDMovieViewController,
            let cell = sender as? MDMoviePreviewCell
        {
            movieVC.movie = cell.movie
        }
        super.prepare(for: segue, sender: sender)
    }
    
}

extension MDListMovieViewController: MDCollectionViewDataSourceProtocol {
    func collectionView(_ collectionView: UICollectionView, itemSizeAt indexPath: IndexPath) -> CGSize {
        let screenWidth = uiConstant.screenWidth
        let cellWidth = (screenWidth - (uiConstant.numberOfCellsPerLine + 1) * uiConstant.cellInterSpace) / uiConstant.numberOfCellsPerLine
        return CGSize(width: cellWidth, height: cellWidth * uiConstant.cellRatio)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height + uiConstant.loadMoreBottomThresshold >= scrollView.contentSize.height && scrollView.contentSize.height > 0 {
            viewModel.loadMore()
        }
    }
}
