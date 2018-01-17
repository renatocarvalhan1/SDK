//
//  CNCBCentralManager.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 11/6/17.
//

import Foundation
import CoreBluetooth

@objc protocol CNCBCentralManagerDelegate {
    
    /// When success request
    @objc optional func requestFinished() -> Void
    /// When not found
    @objc optional func requestNotFound() -> Void
    /// Error
    @objc optional func requestFailed(error: NSError) -> Void
}

class CNCBCentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var delegate: CNCBCentralManagerDelegate?
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral!
    
    static var shared: CNCBCentralManager = {
        return CNCBCentralManager()
    }()
    
    func start() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        self.perform(#selector(stop), with: nil, afterDelay: 20.0)
    }
    
    @objc func stop() {
//        centralManager.stopScan()
//        delegate!.requestNotFound!()
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            print("CoreBluetooth BLE hardware is powered on and ready")
            break
        case .poweredOff:
            print("CoreBluetooth BLE hardware is powered off")
            break
        case .unknown:
            print("CoreBluetooth BLE state is unknown")
            break
        case .unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform")
            break
        case .unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
            break
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager.stopScan()
        print(peripheral.identifier)
        peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredPeripheral = peripheral
        central.connect(discoveredPeripheral, options: nil)
        
    }
}
