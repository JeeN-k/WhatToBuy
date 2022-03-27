//
//  NetworkService.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

enum RequestErrors: Error {
    case invalidEndPoint
    case responseError
}

protocol NetworkServiceProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class NetworkService {
    static let networkService = NetworkService()
}

extension NetworkService: NetworkServiceProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        guard var urlComponent = URLComponents(string: request.url) else {
            completion(.failure(RequestErrors.invalidEndPoint))
            return
        }
        
        var queryitems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            //            urlComponent.queryItems?.append(urlQueryItem)
            queryitems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryitems
        
        guard let url = urlComponent.url else {
            completion(.failure(RequestErrors.invalidEndPoint))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(RequestErrors.responseError))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
