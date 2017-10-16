//
//  CNConnection.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 10/14/17.
//

import UIKit
import FirebaseCommunity

struct CNConnection {
    
    var deviceDisplayName: String?
    var deviceFirmwareVersione: String?
    var deviceIconURL: String?
    var deviceName: String?
    var deviceSerial: String?
    var integrationMethod: String?
    var lastLog: String?
    var lastSyncStatus: String?
    var lastSyncTime: String?
    var macAddress: String?
    var params: [String: String]?
    
    init(data: [String: Any]) {
        self.deviceDisplayName = data["deviceDisplayName"] as? String ?? ""
        self.deviceFirmwareVersione = data["deviceFirmwareVersione"] as? String ?? ""
        self.deviceIconURL = data["deviceIconURL"] as? String ?? ""
        self.deviceName = data["deviceName"] as? String ?? ""
        self.deviceSerial = data["deviceSerial"] as? String ?? ""
        self.integrationMethod = data["integrationMethod"] as? String ?? ""
        self.lastLog = data["lastLog"] as? String ?? ""
        self.lastSyncStatus = data["lastSyncStatus"] as? String ?? ""
        self.lastSyncTime = data["lastSyncTime"] as? String ?? ""
        self.macAddress = data["macAddress"] as? String ?? ""
        self.params = data["params"] as? [String: String] ?? [:]
    }
}
