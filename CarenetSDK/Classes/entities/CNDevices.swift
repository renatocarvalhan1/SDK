//
//  CNDevices.swift
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

class CNDevices: CNBaseEntity {
    
    var type: String?
    var iconUrl: String?
    var name: String?
    var integrationId: String?
    
    var connectionType: ConnectionType {
        switch type! {
        case "Bluetooth":
            return .Bluetooth
        case "Cloud":
            return .Cloud
        default:
            return .NFC
        }
    }
    
    init?(snapshot: DataSnapshot) {
        super.init()
        if let data = snapshot.value as? [String : Any] {
            self.dbId = data["deviceId"] as? String
            self.createdAt = data["creationDate"] as? String
            type = data["connectionType"] as? String
            iconUrl = data["iconURL"] as? String
            name = data["deviceName"] as? String
            integrationId = data["integrationId"] as? String
        } else {
            return nil
        }
    }
}
