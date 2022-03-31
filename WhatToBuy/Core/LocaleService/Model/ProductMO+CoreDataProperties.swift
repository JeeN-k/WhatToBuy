//
//  ProductMO+CoreDataProperties.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//
//

import Foundation
import CoreData


extension ProductMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductMO> {
        return NSFetchRequest<ProductMO>(entityName: "ProductMO")
    }

    @NSManaged public var name: String
    @NSManaged public var count: Int32
    @NSManaged public var price: Float
    @NSManaged public var note: String?
    @NSManaged public var isBought: Bool
    @NSManaged public var category: String
    @NSManaged public var id: String
    @NSManaged public var productList: ProductListMO?

}

extension ProductMO : Identifiable {

}
