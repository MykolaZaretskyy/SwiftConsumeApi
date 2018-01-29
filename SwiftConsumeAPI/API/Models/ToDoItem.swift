//
//  ToDoItem.swift
//  SwiftConsumeAPI
//
//  Created by Mykola Zaretskyy on 1/29/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ToDoItem {
    let userId: Int?
    let id: Int?
    let title: String?
    let completed: Bool?
    
    static func Create(fromJson json: JSON) -> ToDoItem {
        return ToDoItem(userId: json["userId"].int,
                        id: json["id"].int,
                        title: json["title"].string,
                        completed: json["completed"].bool)
    }
}
