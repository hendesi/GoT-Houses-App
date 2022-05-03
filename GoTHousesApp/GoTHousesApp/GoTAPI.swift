//
//  GoTAPI.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 02.05.22.
//

import Foundation
import UIKit

class GoTAPI {
    
    enum GoTResources {
        case houses
        case char(id: String)
        
        var url: URL? {
            switch self {
            case .houses:
                return URL(string: "https://www.anapioficeandfire.com/api/houses")
            case .char(let id):
                return URL(string: "https://www.anapioficeandfire.com/api/characters/\(id)")
            }
        }
    }
    
    static func load<T: Codable>(url: URL?, onSuccess: @escaping ((T) -> Void), onFailure: @escaping ((Error) -> Void)) {
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
    
    static func loadAllHouses(onSuccess: @escaping (([House]) -> Void), onFailure: @escaping ((Error) -> Void)) {
        let request = URLRequest(url: URL(string: "https://www.anapioficeandfire.com/api/houses")!)
        
        let dataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                return onFailure(error)
            }
            guard let data = data else {
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
}

enum APIError: Error {
    case noData
    case noURL
}
