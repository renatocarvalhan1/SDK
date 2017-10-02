//
//  CNWebService.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 26/09/17.
//  Copyright © 2017 Renato Carvalhan. All rights reserved.
//

import UIKit
import RestKit

@objc protocol CNWebServiceDelegate {
    
    /// When no response needs to be handled
    @objc optional func requestFinished() -> Void
    /// When a single object needs to be handled
    @objc optional func requestFinished(entity: CNBaseEntity) -> Void
    /// When an array of objects needs to be handled
    @objc optional func requestFinished(entities: [CNBaseEntity]) -> Void
    /// When a response without mapping needs to be handled
    @objc optional func requestFinished(response: [String : Any]) -> Void
    /// Error
    @objc optional func requestFailed(error: NSError) -> Void
}

class CNWebService: NSObject {
    
    var delegate: CNWebServiceDelegate?
    private var objectManager: RKObjectManager!
    static var sharedService: CNWebService = {
        let instance = CNWebService()
        instance.objectManager = RKObjectManager(baseURL: URL(string: instance.sdk.baseUrl))
        
        RKMIMETypeSerialization.registerClass(RKNSJSONSerialization.self, forMIMEType: "text/json")
        
        return instance
    }()
    
    private let sdk: CarentSDK = {
        CarentSDK.shared as CarentSDK
    }()
    
    private let apiNamespace = "/v2"

    func login(email: String, password: String) {
        let path = "\(apiNamespace)/auth/sdk/ios"
        let status = RKStatusCodeIndexSetForClass(.successful)
        
        let responseDescriptor = RKResponseDescriptor(mapping: emptyMapping,
                                                      method: .any,
                                                      pathPattern: path,
                                                      keyPath: nil,
                                                      statusCodes: status)
        
        objectManager.addResponseDescriptor(responseDescriptor)
        
        objectManager.post(nil, path: path, parameters: ["email" : email, "password" : password], success: { (operation, result) in
            
            let resp = try! JSONSerialization.jsonObject(with: operation!.httpRequestOperation.responseData, options: []) as! [String : AnyObject]
            
//            User.accessToken = resp["tokenAscii"] as? String
//            User.userId = resp["userId"] as? Int
            
            self.delegate?.requestFinished!()
        }) { (operation, error) in
//            if error!._code == -1009 {
//                self.appDelegate.showNoInternetScreen()
//                return
//            }
            
            let mError = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey : "E-mail ou senha inválidos."])
            
            self.delegate?.requestFailed!(error: mError)
        }
        objectManager.removeResponseDescriptor(responseDescriptor)
    }
    
    // MARK: - Mappings
    
    // User
    
    // Empty mapping used to trick RestKit response need
    private let emptyMapping: RKObjectMapping = {
        return RKObjectMapping(for: NSObject.self)!
    }()
    
}
