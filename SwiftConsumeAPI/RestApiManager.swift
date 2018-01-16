//
//  RestApiManager.swift
//  SwiftConsumeAPI
//
//  Created by Mykola Zaretskyy on 1/13/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//
import Foundation
import SwiftyJSON

class ToDoItem {
    var userId: Int?
    var id: Int?
    var title: String?
    var completed: Bool?
    init(json: JSON) {
        userId = json["userId"].int
        id = json["id"].int
        title = json["title"].string
        completed = json["completed"].bool
    }
}
class RestApiManager: NSObject {
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    
    func getTodos(onCompletion: @escaping ([ToDoItem]) -> Void) {
        let todosUrlString = baseURL + "todos"
        makeHTTPGetRequest(path: todosUrlString, onCompletion:
            {(json, error) in
                guard error == nil else {
                    print("error calling GET on /todos")
                    print(error!)
                    return
                }
                
                var todos = [ToDoItem]()
                if let items = json.array {
                    for item in items {
                        todos.append(ToDoItem(json: item))
                    }
                }
                onCompletion(todos)
            })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping (JSON, Error?) -> Void) {
        let request = URLRequest(url: URL(string: path)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let jsonData = data else {
                onCompletion(JSON.null, error)
                return
            }
            
            do {
                let json = try JSON(data: jsonData)
                onCompletion(json, error)
            } catch {
                print("error parsing JSON")
                return
            }
            
        })
        task.resume()
    }
}
