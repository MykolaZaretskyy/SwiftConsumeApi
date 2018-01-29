//
//  ApiOperation.swift
//  SwiftConsumeAPI
//
//  Created by Mykola Zaretskyy on 1/28/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum ApiResult<Value, Error: Swift.Error> {
    case Success(Value)
    case Failure(Error)
}

/// Errors representation in the project.
public enum ApiError : Error {
    /// Operation was cancelled.
    case OperationCancelled
    /// User needs to be logged in before requesting data.
    case LogInNeeded
    /// User with provided creds was not found.
    case UnknownUser
    /// Not enough information to finish the request.
    case MissingData
    /// Response can't be recognized.
    case CorruptedResponse
    /// Network Error with description.
    case NetworkError(String)
    /// Generic Error that didn't fit in any above description.
    case Error(String)
}

class ApiOperation: Operation {
    private var _isExecuting = false
    private var _isFinished = false
    private var _requestUrl: String
    private var _apiManager: ApiManagerProtocol
    internal var completionHandler:((ApiResult<JSON, ApiError>) -> Void)?
    
    init(requestUrl: String, apiManager: ApiManagerProtocol) {
        _requestUrl = requestUrl
        _apiManager = apiManager
        super.init()
    }
    
    override var isExecuting: Bool {
        get { return _isExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isFinished: Bool {
        get { return _isFinished }
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isAsynchronous: Bool {
        get { return true }
    }
    
    override final func start() {
        if self.isCancelled {
            completionHandler?(.Failure(.OperationCancelled))
            isFinished = true
            return
        }
        
        isExecuting = true
        
        _apiManager.request(path: _requestUrl, onCompletion: {(result) -> Void in
            if self.isCancelled {
                self.completionHandler?(.Failure(.OperationCancelled))
            } else {
                self.completionHandler?(result)
            }
            
            isExecuting = false
            isFinished = true
        })
    }
}
