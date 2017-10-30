 //
//  CNDevicesViewController.swift
//  Pods
//
//  Created by Renato Carvalhan on 03/10/17.
//
//

import UIKit
import FirebaseCommunity

class CNDevicesViewController: CNBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var integration: CNIntegration!
    var devices: [CNDevice]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CNDeviceCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNDeviceCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDevices()
    }
    
    func loadDevices() {
        devices = [CNDevice]()
        
        CNDatabase.fetchConnectionByUser { (connections) in
            self.integration.devices.forEach { (key, value) in
                CNDatabase.devicesDatabaseReference(device: key).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let data = snapshot.value as? [String: Any] else { return }
                    var device = CNDevice(data: data)
                    device.id = key
                    
                    if connections.count > 0 {
                        let connectedByUser = connections.contains(where: { (connection) -> Bool in
                            connection.deviceId == key
                        })
                        
                        if connectedByUser {
                            device.connectedByUser = true
                        }
                    }
                    
                    self.devices.append(device)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func animateCellAndShowMyDevices(cell: CNDeviceCell) {
        UIView.animate(withDuration: 0.3, animations: {
            cell.contentLabel.alpha = 0
            cell.loading.alpha = 0
        }, completion: { (complete) in
            UIView.animate(withDuration: 0.2, animations: {
                cell.loading.stopAnimating()
                cell.statusIcon.alpha = 1
                cell.contentLabel.alpha = 1
                cell.contentLabel.textColor = self.cnGreen
                cell.contentLabel.text = "Já faz parte da sua lista"
                cell.statusIcon.image = UIImage(named: "icon-checked", in: CarenetSDK.shared.bundle, compatibleWith: nil)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                CarenetSDK.shared.showMainViewController()
            })
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if devices == nil || devices.count == 0 { return 0 }
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNDeviceCell" , for: indexPath) as! CNDeviceCell
        let device = devices[indexPath.row]
        
        cell.logoView?.sd_setImage(with: URL.init(string: device.iconUrl), completed: nil)
        cell.titleLabel.text = device.name
        cell.contentLabel.text = device.integrationId
        cell.loading.isHidden = true
        cell.loading.hidesWhenStopped = true
        
        if device.connectedByUser {
            cell.contentLabel.textColor = self.cnGreen
            cell.contentLabel.text = "Já faz parte da sua lista"
            cell.statusIcon.image = UIImage(named: "icon-checked", in: CarenetSDK.shared.bundle, compatibleWith: nil)
        } else {
            cell.contentLabel.textColor = UIColor.darkGray
            cell.statusIcon.image = UIImage(named: "icon-add", in: CarenetSDK.shared.bundle, compatibleWith: nil)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        
        if !device.connectedByUser {
            let cell = tableView.cellForRow(at: indexPath) as! CNDeviceCell
            UIView.animate(withDuration: 0.3, animations: {
                cell.statusIcon.alpha = 0
            }, completion: { (complete) in
                UIView.animate(withDuration: 0.2, animations: {
                    cell.loading.alpha = 1
                    cell.loading.isHidden = false
                    cell.loading.startAnimating()
                })
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let connection = [
                        "deviceId" : device.id!,
                        "deviceDisplayName" : device.name,
                        "deviceFirmwareVersione" : "",
                        "deviceName" : device.name,
                        "deviceSerial" : "",
                        "integrationMethod" : "",
                        "lastLog" : "",
                        "lastSyncStatus" : "",
                        "lastSyncTime" : "",
                        "macAddress" : "",
                        "params" : ""
                    ] as [String : Any]
                
                CNDatabase.connectionsDatabaseReference().childByAutoId().updateChildValues(connection, withCompletionBlock: { (err, ref) in
                    self.animateCellAndShowMyDevices(cell: cell)
                })
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
