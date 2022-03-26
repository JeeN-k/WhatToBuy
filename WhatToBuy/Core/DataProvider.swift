//
//  DataProvider.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import Foundation

protocol DataProviderProtocol {
    func fetchLocalProducts(completion: @escaping((ProductSectionsBundle?) -> Void))
    func fetchLists(completion: @escaping(([ProductList]?) -> Void))
    func createNewList(productList: ProductList)
}

class DataProvider: DataProviderProtocol {
    private let bundleLoader = BundleContentLoader()
    private let coreDataManager = CoreDataManager.instance
    
    func fetchLists(completion: @escaping (([ProductList]?) -> Void)) {
        coreDataManager.fetchProductList { lists in
            completion(lists)
        }
    }
    
    func createNewList(productList: ProductList) {
        coreDataManager.saveProductList(productList: productList)
    }
    
    func fetchLocalProducts(completion: @escaping ((ProductSectionsBundle?) -> Void)) {
        do {
            let localProducts = try bundleLoader.loadBundledContent(fromFileNamed: "productsjs")
            completion(localProducts)
        } catch {
            print(error)
        }
    }
}
