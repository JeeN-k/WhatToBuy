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
    func fetchProduts(productListID: String, completion: @escaping([Product]?) -> Void)
    func deleteProductList(productListID: String)
    func addProductToList(product: Product, productListID: String)
    func deleteProduct(productId: String)
    func fetchRemovedProductLists(completion: @escaping(([ProductList]?) -> Void))
}

class DataProvider: DataProviderProtocol {
    private let bundleLoader = BundleContentLoader()
    private let coreDataManager = CoreDataManager.instance
    private let networkServie = NetworkService.instance
    var isOfflineMode = false
    
    func fetchLists(completion: @escaping (([ProductList]?) -> Void)) {
        if isOfflineMode {
            coreDataManager.fetchProductList { lists in
                completion(lists)
            }
        } else {
            let fetchListsRequest = FetchListsRequest()
            networkServie.request(fetchListsRequest) { result in
                switch result {
                case .success(let lists):
                    completion(lists.data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func deleteProduct(productId: String) {
        if isOfflineMode {
            
        } else {
            let deleteProductRequest = DeleteProductRequest(productId: productId)
            networkServie.request(deleteProductRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func createNewList(productList: ProductList) {
        if isOfflineMode {
            coreDataManager.saveProductList(productList: productList)
        } else {
            let newListRequest = NewListRequest(productList: productList)
            networkServie.request(newListRequest) { result in
                switch result {
                case .success(let response):
                    print(response.success)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchLocalProducts(completion: @escaping ((ProductCategoriesBundle?) -> Void)) {
        do {
            let localProducts = try bundleLoader.loadBundledContent(fromFileNamed: "productsjs")
            completion(localProducts)
        } catch {
            print(error)
        }
    }
    
    func fetchProduts(productListID: String, completion: @escaping([Product]?) -> Void) {
        if isOfflineMode {
            coreDataManager.fetchProducts(listId: productListID) { products in
                completion(products)
            }
        } else {
            let fetchProductsRequest = FetchProductsRequest(listId: productListID)
            networkServie.request(fetchProductsRequest) { result in
                switch result {
                case .success(let response):
                    completion(response.products)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func deleteProductList(productListID: String) {
        if isOfflineMode {
            coreDataManager.deleteProductList(id: productListID)
        } else {
            let removeToTrashRequest = RemoveToTrashRequest(listId: productListID)
            networkServie.request(removeToTrashRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func addProductToList(product: Product, productListID: String) {
        if isOfflineMode {
            coreDataManager.addProductToProductList(id: productListID, product: product)
        } else {
            let newProductRequest = NewProductRequest(listId: productListID, product: product)
            networkServie.request(newProductRequest) { result in
                switch result {
                case .success(let response):
                    print(response.success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchRemovedProductLists(completion: @escaping(([ProductList]?) -> Void)) {
        if isOfflineMode {
            
        } else {
            let removedProductListsRequest = FetchRemovedListsRequest()
            networkServie.request(removedProductListsRequest) { result in
                switch result {
                case .success(let response):
                    completion(response.data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
