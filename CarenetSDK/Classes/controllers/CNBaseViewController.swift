//
//  CNBaseViewController.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 21/09/17.
//  Copyright © 2017 Renato Carvalhan. All rights reserved.
//

import UIKit

public class CNBaseViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Dispositivos"
        cnNavigationBar()
    }
    
    func cnNavigationBar() {
        navigationController?.navigationBar.tintColor = cnGreen
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    lazy var cnGreen: UIColor = {
        return UIColor(red: 8/255, green: 190/255, blue: 161/255, alpha: 1)
    }()
}
