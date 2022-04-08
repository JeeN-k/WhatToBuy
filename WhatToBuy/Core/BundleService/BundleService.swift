//
//  BundleContentLoader.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import Foundation

class BundleService {
    static let instance = BundleService()
    
    enum Error: Swift.Error {
        case fileNotFound(name: String)
        case fileDecodingFailed(name: String, Swift.Error)
    }
    
    private func loadBundledContent(fromFileNamed name: String) throws -> ProductCategoriesBundle {
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "json"
        ) else {
            throw Error.fileNotFound(name: name)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(ProductCategoriesBundle.self, from: data)
        } catch {
            throw Error.fileDecodingFailed(name: name, error)
        }
    }
    
    func fetchListOfLocalProducts(completion: @escaping(ProductCategoriesBundle) -> Void) {
        do {
            let localProducts = try loadBundledContent(fromFileNamed: "productsjs")
            completion(localProducts)
        } catch {
            print(error)
        }
    }
}
