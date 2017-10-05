//
//  ViewController.swift
//  CarenetSDK
//
//  Created by renatocarvalhan1 on 10/01/2017.
//  Copyright (c) 2017 renatocarvalhan1. All rights reserved.
//

import UIKit
import CarenetSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        CarenetSDK.shared.startSDKWithClientId()
    }

}

