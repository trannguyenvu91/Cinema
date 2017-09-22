//
//  CinemaTests.swift
//  CinemaTests
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import XCTest
@testable import Cinema

class MDCollectionViewDataSourceTest: XCTestCase {
    
    var dataSource: MDCollectionViewDataSource!
    var collectionView: UICollectionView!
    let collectionLayout = UICollectionViewLayout()
    private let dataProvider = MockDataProvider()
    
    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionLayout)
        collectionView.register(MDMockCell.classForCoder(), forCellWithReuseIdentifier: "Cell")
        dataSource = MDCollectionViewDataSource(collectionView: collectionView, owner: dataProvider, dataProvider: dataProvider, cellID: "Cell")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadData() {
        XCTAssert(checkCollectionViewDataMatch(), "number of cells and items must be equal!")
    }
    
    func testReloadNotification() {
        dataProvider.insertData(models: [MDMockModel(), MDMockModel()])
        dataProvider.reloadNotification?()
        XCTAssert(checkCollectionViewDataMatch(), "Binder should reload collectionView")
    }
    
    func checkCollectionViewDataMatch() -> Bool {
        let modelCount = dataProvider.data.count
        let cellCount = collectionView.numberOfItems(inSection: 0)
        return modelCount == cellCount
    }
    
}


private final class MockDataProvider: NSObject, MDListProviderProtocol, MDCollectionViewDataSourceProtocol {
    var data = [MDMockModel(), MDMockModel()]
    
    func insertData(models: [MDMockModel]) {
        data.append(contentsOf: models)
    }
    
    func model(at indexPath: IndexPath) -> MDModelProtocol? {
        return data[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return data.count
    }
    
    var reloadNotification: (() -> Void)?
    
    var updatesNotification: (([IndexPath], [IndexPath], [IndexPath]) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, itemSizeAt indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
    
}

private final class MDMockCell: UICollectionViewCell, MDModelViewProtocol {
    func setup(with model: MDModelProtocol?) {}
}

private final class MDMockModel: MDModelProtocol {}
