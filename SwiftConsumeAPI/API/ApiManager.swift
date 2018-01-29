//
//  RestApiManager.swift
//  SwiftConsumeAPI
//
//  Created by Mykola Zaretskyy on 1/13/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//
import Foundation
import SwiftyJSON

protocol ApiManagerProtocol {
    func request(path: String, onCompletion: @escaping (ApiResult<JSON, ApiError>) -> Void)
}

class ApiManager: ApiManagerProtocol {
    private let baseURL = "https://jsonplaceholder.typicode.com/"

    // MARK: Perform a GET Request
    internal func request(path: String, onCompletion: @escaping (ApiResult<JSON, ApiError>) -> Void) {
        let request = URLRequest(url: URL(string: path)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let jsonData = data else {
                onCompletion(.Success(JSON.null))
                return
            }
            
            do {
                let json = try JSON(data: jsonData)
                onCompletion(.Success(json))
            } catch {
                onCompletion(.Failure(.MissingData))
                return
            }
            
        })
        task.resume()
    }
}

