//
//  RestApiManager.swift
//  SwiftConsumeAPI
//
//  Created by Mykola Zaretskyy on 1/13/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//
import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void
class ToDoItem {
    var userId: Int?
    var id: Int?
    var title: String?
    var completed: Bool?
    init(userId: Int?, id: Int?, title: String?, completed: Bool?) {
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
}
class RestApiManager: NSObject {
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    
    func getTodos(onCompletion: (JSON) -> Void) {
        let todosUrlString = baseURL + "todos"
        makeHTTPGetRequest(path: todosUrlString, onCompletion:
            {(data, response, error) in
                guard error == nil else {
                    print("error calling GET on /todos")
                    print(error!)
                    return
                }
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                do {
                    guard let todos = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [Any] else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    
                    let todoItems = todos.filter{ $0 is [String: Any]}
                        .map ({
                        (value: Any) -> ToDoItem in
                        let todo = value as! [String: Any]
                        
                        let userId = todo["userId"] as? Int
                        let id = todo["id"] as? Int
                        let title = todo["title"] as? String
                        let completed = todo["completed"] as? Bool
                        return ToDoItem(userId: userId, id: id, title: title, completed: completed)
                    })
                } catch {
                    print("error trying to convert data to JSON")
                    return
                }
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
