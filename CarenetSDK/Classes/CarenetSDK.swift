//
//  CarentSDK.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 21/09/17.
//  Copyright © 2017 Renato Carvalhan. All rights reserved.
//

import UIKit
import FirebaseCommunity

public class CarenetSDK: NSObject {
    
    public static var shared: CarenetSDK = {
        let instance = CarenetSDK()
        FirebaseApp.configure()
        return instance
    }()
    
    var bundle: Bundle = {
        let bundleurl = Bundle(for: CarenetSDK.self).url(forResource: "CarenetSDK", withExtension: "bundle")
        
        return Bundle(url: bundleurl!)!
    }()
    
    var deviceID: String = {
      UIDevice.current.identifierForVendor!.uuidString
    }()
    
    public func startSDK(with email: String!, password: String!) {
        CNDatabase.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to sign in with email:", err)
                return
            }
            
            self.showMainViewController(startSDK: true)
        }
    }
    
    func showMainViewController(startSDK: Bool = false) {
        let storyboard = UIStoryboard(name: "SDK", bundle: bundle)
        var navController = storyboard.instantiateInitialViewController()
        
        CNDatabase.fetchConnectionByUser(completion: { (connections) in
            if connections.count > 0 {
                let controller = storyboard.instantiateInitialViewController() as! CNMyDevicesViewController
                navController = UINavigationController(rootViewController: controller)
            } else {
                let controller = storyboard.instantiateViewController(withIdentifier: "CNIntegrations") as! CNIntegrationsViewController
                navController = UINavigationController(rootViewController: controller)
            }
            
            let window = UIApplication.shared.keyWindow!
            UIView.transition(with: window, duration: 0.5, options: startSDK ? .transitionCrossDissolve : .transitionFlipFromRight, animations: {
                DispatchQueue.main.async {
                    window.rootViewController = navController
                }
            })
        })
    }
}
