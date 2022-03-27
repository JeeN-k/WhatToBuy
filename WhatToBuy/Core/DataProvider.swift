//
//  DataProvider.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import Foundation

protocol DataProviderProtocol {
    func fetchLocalProducts(completion: @escaping((ProductCategoriesBundle?) -> Void))
    func fetchLists(completion: @escaping(([ProductList]?) -> Void))
    func createNewList(productList: ProductList)
    func fetchProduts(completion: @escaping(([Product]?) -> Void))
    func deleteProductList(productListID: String)
}

class DataProvider: DataProviderProtocol {
    private let bundleLoader = BundleContentLoader()
    private let coreDataManager = CoreDataManager.instance
    var isOfflineMode = true
    
    func fetchLists(completion: @escaping (([ProductList]?) -> Void)) {
        if isOfflineMode {
            coreDataManager.fetchProductList { lists in
                completion(lists)
            }
        } else {
            
        }
    }
    
    func createNewList(productList: ProductList) {
        coreDataManager.saveProductList(productList: productList)
    }
    
    func fetchLocalProducts(completion: @escaping ((ProductCategoriesBundle?) -> Void)) {
        do {
            let localProducts = try bundleLoader.loadBundledContent(fromFileNamed: "productsjs")
            completion(localProducts)
        } catch {
            print(error)
        }
    }
    
    func fetchProduts(completion: @escaping (([Product]?) -> Void)) {
        if isOfflineMode {
            coreDataManager.fetchProducts { products in
                completion(products)
            }
        } else {
            
        }
    }
    
    func deleteProductList(productListID: String) {
        if isOfflineMode {
            coreDataManager.deleteProductList(id: productListID)
        } else {
            
        }
    }
}
