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
    func updateProductList(productList: ProductList, productListID: String)
    func updateProduct(product: Product)
    func inviteUserToList(email: String, listId: String)
}

class DataProvider: DataProviderProtocol {
    private let bundleLoader = BundleContentLoader()
    private let coreDataManager = CoreDataManager.instance
    private let networkService = NetworkService.instance
    
    var isOfflineMode:Bool {
        !TokenManager.tokenExists
    }
    
    func fetchLists(completion: @escaping (([ProductList]?) -> Void)) {
        if isOfflineMode {
            coreDataManager.fetchProductList { lists in
                completion(lists)
            }
        } else {
            let fetchListsRequest = FetchListsRequest()
            networkService.request(fetchListsRequest) { result in
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
            print("Can't do this with offline mode yet")
        } else {
            let deleteProductRequest = DeleteProductRequest(productId: productId)
            networkService.request(deleteProductRequest) { result in
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
            networkService.request(newListRequest) { result in
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
            networkService.request(fetchProductsRequest) { result in
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
            networkService.request(removeToTrashRequest) { result in
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
            networkService.request(newProductRequest) { result in
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
            print("Can't do this with offline mode yet")
        } else {
            let removedProductListsRequest = FetchRemovedListsRequest()
            networkService.request(removedProductListsRequest) { result in
                switch result {
                case .success(let response):
                    completion(response.data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateProductList(productList: ProductList, productListID: String) {
        if isOfflineMode {
            print("Can't do this with offline mode yet")
        } else {
            let updateProductListRequest = UpdateProductListRequest(productList: productList, productListID: productListID)
            networkService.request(updateProductListRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateProduct(product: Product) {
        if isOfflineMode {
            print("Can't do this with offline mode yet")
        } else {
            let updateProductRequest = UpdateProductRequest(product: product)
            networkService.request(updateProductRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func inviteUserToList(email: String, listId: String) {
        if isOfflineMode {
            print("Can't do this with offline mode yet")
        } else {
            let inviteRequest = InviteToListRequest(listId: listId, email: email)
            networkService.request(inviteRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
