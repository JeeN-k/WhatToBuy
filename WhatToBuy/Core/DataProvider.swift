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
    func removeToTrashProductList(productListID: String)
    func addProductToList(product: Product, productListID: String)
    func deleteProduct(productId: String)
    func fetchRemovedProductLists(completion: @escaping(([ProductList]?) -> Void))
    func updateProductList(productList: ProductList, productListID: String)
    func updateProduct(product: Product, completion: @escaping()->())
    func inviteUserToList(email: String, listId: String, completion: @escaping(BasicResponse?) -> Void)
    func fetchUserInvites(completion: @escaping(([Invite]?) -> Void))
    func answerToInvite(answerType: AnswerInviteType, listId: String)
    func restoreFromTrashProductList(listId: String)
    func deleteProductList(listId: String)
    func productIsBoughtUpdate(productId: String, isBought: Bool)
    func changeUserPassword(oldPassword: String, newPassword: String, completion: @escaping(BasicResponse?) -> Void)
}

class DataProvider: DataProviderProtocol {
    private let bundleLoader = BundleContentLoader()
    private let coreDataManager = CoreDataManager.instance
    private let networkService = NetworkService.instance
    
    private var isOfflineMode:Bool {
        !AccountManager.authTokenExists || AccountManager.isOfflineMode
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
            coreDataManager.deleteProduct(id: productId)
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
    
    func removeToTrashProductList(productListID: String) {
        if isOfflineMode {
            coreDataManager.removeListToTrash(listId: productListID)
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
            coreDataManager.fetchRemovedLists { lists in
                completion(lists)
            }
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
            coreDataManager.updateProductList(productList: productList, productListId: productListID)
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
    
    func updateProduct(product: Product, completion: @escaping()->()) {
        if isOfflineMode {
            coreDataManager.updateProduct(product: product) {
                completion()
            }
        } else {
            let updateProductRequest = UpdateProductRequest(product: product)
            networkService.request(updateProductRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func inviteUserToList(email: String, listId: String, completion: @escaping(BasicResponse?) -> Void) {
        if isOfflineMode {
            print("Can't do this with offline mode")
        } else {
            let inviteRequest = InviteToListRequest(listId: listId, email: email)
            networkService.request(inviteRequest) { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchUserInvites(completion: @escaping(([Invite]?) -> Void)) {
        if isOfflineMode {
            print("Can't do this with offline mode")
        } else {
            let fetchInvitesRequest = FetchInvitesRequest()
            networkService.request(fetchInvitesRequest) { result in
                switch result {
                case .success(let response):
                    completion(response.data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func answerToInvite(answerType: AnswerInviteType, listId: String) {
        if isOfflineMode {
            print("Can't do this with offline mode")
        } else {
            let answerInviteRequest = AnswerInviteRequest(listId: listId, answerType: answerType)
            networkService.request(answerInviteRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func restoreFromTrashProductList(listId: String) {
        if isOfflineMode {
            coreDataManager.restoreListFromTrash(listId: listId)
        } else {
            let restoreFromTrashRequest = RestoreFromTrashRequest(listId: listId)
            networkService.request(restoreFromTrashRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func deleteProductList(listId: String) {
        if isOfflineMode {
            coreDataManager.deleteProductList(id: listId)
        } else {
            let deleteProductList = TotalDeleteListRequest(listId: listId)
            networkService.request(deleteProductList) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func productIsBoughtUpdate(productId: String, isBought: Bool) {
        if isOfflineMode {
            coreDataManager.productBoughtUpdate(productId: productId, isBought: isBought)
        } else {
            let boughtChangeRequest = BoughtUpdateRequest(productId: productId, isBought: isBought)
            networkService.request(boughtChangeRequest) { result in
                switch result {
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func changeUserPassword(oldPassword: String, newPassword: String, completion: @escaping(BasicResponse?) -> Void) {
        if !isOfflineMode {
            let newPasswordRequest = ChangePasswordRequest(oldPassword: oldPassword, newPassword: newPassword)
            networkService.request(newPasswordRequest) { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
