//
//  CoreDataManager.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import CoreData

protocol CoreDataManagerProtocol {
    func saveProductList(productList: ProductList)
    func fetchProductList(_ completion: @escaping(([ProductList]) -> Void))
    func addProductToProductList(id: String, product: Product)
    func fetchProducts(listId: String, completion: @escaping([Product]) -> Void)
    func deleteProductList(id: String)
}

final class CoreDataManager {
    
    static let instance: CoreDataManagerProtocol = CoreDataManager()
    
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

extension CoreDataManager: CoreDataManagerProtocol {
    
    func saveProductList(productList: ProductList) {
        let productListMO = ProductListMO(context: moc)
        productListMO.setValue(productList.name, forKey: "name")
        productListMO.setValue(productList.icon, forKey: "icon")
        productListMO.setValue(productList.color, forKey: "color")
        productListMO.setValue(productList._id, forKey: "id")
        
        do {
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchProductList(_ completion: @escaping(([ProductList]) -> Void)) {
        do {
            let fetchRequest = NSFetchRequest<ProductListMO>(entityName: "ProductListMO")
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
            print("Success")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension CoreDataManager {
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
}
