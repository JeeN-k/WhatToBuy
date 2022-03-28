//
//  ProductListMO+CoreDataProperties.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//
//

import Foundation
import CoreData


extension ProductListMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductListMO> {
        return NSFetchRequest<ProductListMO>(entityName: "ProductListMO")
    }

    @NSManaged public var name: String
    @NSManaged public var color: String
    @NSManaged public var icon: String
    @NSManaged public var id: String
    @NSManaged public var products: Set<ProductMO>?

}

// MARK: Generated accessors for products
extension ProductListMO {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ProductMO)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ProductMO)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension ProductListMO : Identifiable {

}
