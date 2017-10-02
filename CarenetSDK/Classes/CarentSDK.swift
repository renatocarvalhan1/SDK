//
//  CarentSDK.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 21/09/17.
//  Copyright © 2017 Renato Carvalhan. All rights reserved.
//

import UIKit

public class CarentSDK: NSObject {
    
    public static var shared: CarentSDK = {
        let instance = CarentSDK()
        return instance
    }()
    
    var baseUrl: String = {
        "http://dev.crnt.com.br"
        //        "http://api.pareaqui.com.br"
    }()
    
    var bundle: Bundle = {
        Bundle(for: CarentSDK.self)
    }()
    
    var deviceID: String = {
      UIDevice.current.identifierForVendor!.uuidString
    }()
    
    public func startSDKWithClientId() {
        
        let storyboard = UIStoryboard(name: "SDK", bundle: bundle)
        let centerController = UINavigationController(rootViewController: storyboard.instantiateInitialViewController()!)
        
        UIApplication.shared.keyWindow?.rootViewController = centerController
    }

}
