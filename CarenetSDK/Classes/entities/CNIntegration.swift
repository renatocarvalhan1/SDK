//
//  CNIntegration.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit
import FirebaseCommunity

class CNIntegration: CNBaseEntity {
    
    var devices: [String]?
    var iconUrl: String?
    var name: String?
    
    init?(snapshot: DataSnapshot) {
        super.init()
        if let data = snapshot.value as? [String : Any] {
            self.dbId = data["integrationId"] as? String
            self.createdAt = data["creationDate"] as? String
            devices = data["devices"] as? [String]
            iconUrl = data["iconURL"] as? String
            name = data["integrationName"] as? String
        } else {
            return nil
        }
    }

}
