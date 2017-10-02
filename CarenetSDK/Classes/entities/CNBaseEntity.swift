//
//  CNBaseEntity.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 29/09/17.
//  Copyright © 2017 Renato Carvalhan. All rights reserved.
//

import UIKit

class CNBaseEntity: NSObject {
    
    var clientId: String?
    var clientSecret: String?
    var dbId: String!
    
    func requestAttributes() -> [String : String] {
        fatalError("requestAttributes must be overridden")
    }
    
    func responseAttributes() -> [String : String] {
        fatalError("responseAttributes must be overridden")
    }
}
