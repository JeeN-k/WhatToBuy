//
//  CoreDataManager.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import CoreData

protocol CoreDataServiceProtocol {
    func saveProductList(productList: ProductList)
    func fetchProductList(_ completion: @escaping(([ProductList]) -> Void))
    func addProductToProductList(id: String, product: Product)
    func fetchProducts(listId: String, completion: @escaping([Product]) -> Void)
    func deleteProductList(id: String)
    func deleteProduct(id: String)
    func removeListToTrash(listId: String)
    func fetchRemovedLists(_ completion: @escaping([ProductList]?) -> Void)
    func restoreListFromTrash(listId: String)
    func updateProductList(productList: ProductList, productListId: String)
    func updateProduct(product: Product, completion: @escaping() -> Void)
    func productBoughtUpdate(productId: String, isBought: Bool)
}

final class CoreDataService {
    
    static let instance: CoreDataServiceProtocol = CoreDataService()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "WhatToBuyApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return persistentContainer
    }()
    
    private var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

extension CoreDataService: CoreDataServiceProtocol {
    
    func saveProductList(productList: ProductList) {
        let productListMO = ProductListMO(context: moc)
        productListMO.setValue(productList.name, forKey: "name")
        productListMO.setValue(productList.icon, forKey: "icon")
        productListMO.setValue(productList.color, forKey: "color")
        productListMO.setValue(productList._id, forKey: "id")
        productListMO.setValue(false, forKey: "isRemoved")
        do {
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchProductList(_ completion: @escaping(([ProductList]) -> Void)) {
        do {
            let fetchRequest = NSFetchRequest<ProductListMO>(entityName: "ProductListMO")
            fetchRequest.predicate = NSPredicate(format: "isRemoved = false")
            let productListsMO = try moc.fetch(fetchRequest)
            let productLists = productListsMO.map({ ProductList(record: $0) })
            completion(productLists)
        } catch {
            print(error)
        }
    }
    
    func addProductToProductList(id: String, product: Product) {
        guard let productList = getProductListById(id) else { return }
        let productMO = ProductMO(context: moc)
        productMO.setValue(product.name, forKey: "name")
        productMO.setValue(product.count, forKey: "count")
        productMO.setValue(product.note, forKey: "note")
        productMO.setValue(product.category, forKey: "category")
        productMO.setValue(product._id, forKey: "id")
        productMO.setValue(product.isBought, forKey: "isBought")
        productMO.productList = productList
        productList.addToProducts(productMO)
        do {
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchProducts(listId: String, completion: @escaping([Product]) -> Void) {
        guard let productList = getProductListById(listId) else { return }
        guard let productsMO = productList.products else { return }
        let products = Array(productsMO).map({ Product(record: $0) })
        completion(products)
    }
    
    func deleteProductList(id: String) {
        guard let productList = getProductListById(id) else { return }
        moc.delete(productList)
        do {
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteProduct(id: String) {
        guard let product = getProductById(id) else { return }
        moc.delete(product)
        do {
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeListToTrash(listId: String) {
        guard let productList = getProductListById(listId) else { return }
        productList.isRemoved = true
        do {
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func restoreListFromTrash(listId: String) {
        guard let productList = getProductListById(listId) else { return }
        productList.isRemoved = false
        do {
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchRemovedLists(_ completion: @escaping([ProductList]?) -> Void) {
        do {
            let fetchRequest = NSFetchRequest<ProductListMO>(entityName: "ProductListMO")
            fetchRequest.predicate = NSPredicate(format: "isRemoved = true")
            let productListsMO = try moc.fetch(fetchRequest)
            let productLists = productListsMO.map({ ProductList(record: $0) })
            completion(productLists)
        } catch {
            print(error)
        }
    }
    
    func updateProductList(productList: ProductList, productListId: String) {
        guard let productListMO = getProductListById(productListId) else { return }
        productListMO.name = productList.name
        productListMO.icon = productList.icon
        productListMO.color = productList.color
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func updateProduct(product: Product, completion: @escaping() -> Void) {
        guard let productMO = getProductById(product._id) else { return }
        productMO.name = product.name
        productMO.count = Int32(product.count ?? 0)
        productMO.note = product.note
        productMO.price = product.price ?? 0
        do {
            try moc.save()
            completion()
        } catch {
            print(error)
        }
    }
    
    func productBoughtUpdate(productId: String, isBought: Bool) {
        guard let productMO = getProductById(productId) else { return }
        productMO.isBought = isBought
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
}

extension CoreDataService {
    private func getProductListById(_ id: String) -> ProductListMO? {
        let fetchRequest: NSFetchRequest<ProductListMO> = ProductListMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let lists = try moc.fetch(fetchRequest)
            return lists.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getProductById(_ id: String) -> ProductMO? {
        let fetchRequest: NSFetchRequest<ProductMO> = ProductMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let lists = try moc.fetch(fetchRequest)
            return lists.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
