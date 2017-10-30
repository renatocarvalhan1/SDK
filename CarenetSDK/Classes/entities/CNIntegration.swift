//
//  CNIntegration.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit

struct CNIntegration {
    
    var id: String?
    var createdAt: String
    var devices: [String: String]
    var iconUrl: String
    var name: String
    var subtitle: String
    var connectedByUser = false
    
    init(data: [String: Any]) {
        self.createdAt = data["creationDate"] as? String ?? ""
        self.devices = data["devices"] as? [String: String] ?? [:]
        self.iconUrl = data["iconURL"] as? String ?? ""
        self.name = data["integrationName"] as? String ?? ""
        self.subtitle = data["subtitle"] as? String ?? ""
    }

}
