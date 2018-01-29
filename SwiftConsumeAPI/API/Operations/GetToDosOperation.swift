//
//  GetToDosOperation.swift
//  SwiftConsumeAPI
//
//  Created by Mykola Zaretskyy on 1/29/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetToDosOperation: ApiOperation {
    init(completionHandler: @escaping((ApiResult<ToDoItem, ApiError>) -> ())) {
        super.init(requestUrl: "todos", apiManager: ApiManager())
        
        self.completionHandler = { result in
            switch (result) {
            case let .Success(response):
                DispatchQueue.main.async {
                    completionHandler(.Success(ToDoItem.Create(fromJson: response)))
                }
            case let .Failure(error):
                DispatchQueue.main.async {
                    completionHandler(.Failure(error))
                }
        }
    }
    }
}
