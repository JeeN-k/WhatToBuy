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
}
