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
    
    var integrationName: String!
    
    var devices: [CNDevices]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CNDeviceCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNDeviceCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        loadDevices()
    }
    
    func loadDevices() {
        var array = [CNDevices]()
        CNDatabase.devicesDatabaseReference(integration: integrationName).observe(.value, with:{(snapshot) in
            for itemSnapShot in snapshot.children {
                let i = CNDevices(snapshot: itemSnapShot as! DataSnapshot)
                array.append(i!)
            }
            self.devices = array
            self.tableView.reloadData()
        })
    }
    
    @objc func add(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? CNDeviceCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.addButton.alpha = 0
                cell.loading.isHidden = false
                cell.loading.startAnimating()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.contentLabel.alpha = 0
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.loading.isHidden = true
                        cell.addButton.alpha = 1
                        cell.contentLabel.alpha = 1
                        cell.contentLabel.textColor = self.paGreen
                        cell.contentLabel.text = "Já faz parte da sua lista"
                        cell.addButton.setImage(UIImage(named: "icon-sync"), for: .normal)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CNMyDevices") as! CNMyDevicesViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        })
                    })
                })
            })
        }
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
        
        cell.logoView.sd_setImage(with: URL.init(string: device.iconUrl!), completed: nil)
        cell.titleLabel.text = device.name
        cell.contentLabel.textColor = UIColor.darkGray
        cell.contentLabel.text = device.integrationId
        cell.addButton.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        cell.loading.isHidden = true
        cell.loading.hidesWhenStopped = true
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
