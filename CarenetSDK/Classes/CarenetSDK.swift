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
        return instance
    }()
    
    var baseUrl: String = {
        "http://dev.crnt.com.br"
    }()
    
    var bundle: Bundle = {
        let bundleurl = Bundle(for: CarenetSDK.self).url(forResource: "CarenetSDK", withExtension: "bundle")
        
        return Bundle.init(url: bundleurl!)!
    }()
    
    var deviceID: String = {
      UIDevice.current.identifierForVendor!.uuidString
    }()
    
    public func startSDKWithClientId() {
        
    
        FirebaseApp.configure()
        
        let storyboard = UIStoryboard(name: "SDK", bundle: bundle)
        let centerController = UINavigationController(rootViewController: storyboard.instantiateInitialViewController()!)
        
        UIApplication.shared.keyWindow?.rootViewController = centerController
    }

}
