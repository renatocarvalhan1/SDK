//
//  CNDevice.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit
import FirebaseCommunity

enum ConnectionType {
    case Bluetooth
    case Cloud
    case NFC
}

struct CNDevice {
    
    var id: String?
    
    var createdAt: String
    var type: String
    var iconUrl: String
    var name: String
    var integrationId: String
    
    var connectedByUser = false
    
    var connectionType: ConnectionType {
        switch type {
        case "Bluetooth":
            return .Bluetooth
        case "Cloud":
            return .Cloud
        default:
            return .NFC
        }
    }
    
    init(data: [String: Any]) {
        self.createdAt = data["creationDate"] as? String ?? ""
        self.type = data["connectionType"] as? String ?? ""
        self.iconUrl = data["iconURL"] as? String ?? ""
        self.name = data["deviceName"] as? String ?? ""
        self.integrationId = data["integrationId"] as? String ?? ""
    }
}
