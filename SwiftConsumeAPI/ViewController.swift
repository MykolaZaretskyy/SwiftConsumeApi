//
//  ViewController.swift
//  SwiftConsumeAPI
//
//  Created by Mykola Zaretskyy on 1/13/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let apiManager = RestApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.getTodos()
    }
}

