//
//  NetworkManager.swift
//  Advait
//
//  Created by Gaurav Sharma on 09/05/24.
//

import Foundation
import Combine
import SwiftUI

// This can be moved under Utility classes
enum APIError: Error {
    case request(message: String)
    case network(message: String)
    case status(message: String)
    case parsing(message: String)
    case other(message: String)
    
    static func map(_ error: Error) -> APIError {
        return (error as? APIError) ?? .other(message: error.localizedDescription)
    }
}

// Protocol for fetching the data from URL
protocol Fetchable {
    func fetchDataFromTypicalNetworkManager<T: Codable>(url:URL, completion: @escaping (Result<[T], Error>) -> ())
}


// Struct which handles the API calls and conforms to Fetchable Protocol
struct NetworkManager : Fetchable {
    //Create the session
    let session = URLSession.init(configuration: .default)
   
    func fetchDataFromTypicalNetworkManager<T: Codable>(url:URL, completion: @escaping (Result<T, Error>) -> ()) {
        let urlRequest = URLRequest(url: url)
        // Create the data task
        let dataTask = session.dataTask(with: urlRequest) { data,response,error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard response != nil else {
                return completion(.failure(error!))
            }
            
            guard let data = data else {
                return completion(.failure(error!))
            }
            
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                return completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
