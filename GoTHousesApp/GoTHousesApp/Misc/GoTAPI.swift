//
//  GoTAPI.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 02.05.22.
//

import Foundation
import UIKit

class GoTAPI {
    /// Loads the items of the given `[URL]` and transforms them to the provided codable type. The function returns once all loadings have been completed.
    static func load<T: Codable>(_ type: T.Type = T.self, urls: [URL?], onSuccess: @escaping (([T]) -> Void), onFailure: @escaping ((Error) -> Void)) {
        var objects: [T] = []
        let group = DispatchGroup()
        for url in urls {
            group.enter()
            load(type, url: url, onSuccess: { value in
                objects.append(value)
                group.leave()
            }, onFailure: { error in
                group.leave()
                onFailure(error)
            })
        }
        group.notify(queue: .main, execute: {
            onSuccess(objects)
        })
    
    }
    
    /// Loads the items of the given `url` and transforms them to the provided codable type. The function returns once all loadings have been completed.
    static func load<T: Codable>(_ type: T.Type = T.self, url: URL?, onSuccess: @escaping ((T) -> Void), onFailure: @escaping ((Error) -> Void)) {
        guard let url = url else {
            return onFailure(APIError.noURL)
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                return onFailure(error)
            }
            guard let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                return onFailure(APIError.noData)
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                return onSuccess(object)
            } catch {
                return onFailure(error)
            }
        })
        dataTask.resume()
    }
    
    static func loadHouses(page: Int, onSuccess: @escaping (([House]) -> Void), onFailure: @escaping ((Error) -> Void)) {
        let request = URLRequest(url: URL(string: "https://www.anapioficeandfire.com/api/houses?page=\(page)&pageSize=30")!)
        
        let dataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                return onFailure(error)
            }
            guard let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                return onFailure(APIError.noData)
            }
            
            do {
                let houses = try JSONDecoder().decode([House].self, from: data)
                return onSuccess(houses)
            } catch {
                return onFailure(error)
            }
        })
        dataTask.resume()
    }
    
    /// Set page to 2 because initial loading is done with `loadHouses(page:)`
    fileprivate static var page: Int = 2
    static func loadMoreHouses(onSuccess: @escaping (([House]) -> Void), onFailure: @escaping ((Error) -> Void)) {
        loadHouses(page: page, onSuccess: onSuccess, onFailure: onFailure)
        page += 1
    }
}

enum APIError: Error {
    case noData
    case noURL
}
