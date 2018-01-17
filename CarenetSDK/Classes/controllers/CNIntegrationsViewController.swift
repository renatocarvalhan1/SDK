//
//  CNIntegrationsViewController.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit
import SDWebImage
import FirebaseCommunity

class CNIntegrationsViewController: CNBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var integrations: [CNIntegration]?
    var filteredIntegrations = [CNIntegration]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CNDeviceCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNDeviceCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadIntegrations()
    }
    
    func loadIntegrations() {
        integrations = [CNIntegration]()
        
        CNDatabase.fetchConnectionByUser { (connections) in
            if connections.count == 0 { self.showWarning() }
            
            CNDatabase.integrationDatabaseReference().observeSingleEvent(of: .value, with: { (snapshot) in
                guard let values = snapshot.value as? [String: Any] else { return }
                values.forEach({ (key, value) in
                    guard let data = value as? [String: Any] else { return }
                    var integration = CNIntegration(data: data)
                    integration.id = key
                    
                    for (_, device) in integration.devices.enumerated() {
                        if let deviceId = device.key as String? {
                            integration.connectedByUser = true
                            
                            let connectedByUser = connections.contains(where: { (connection) -> Bool in
                                connection.deviceId == deviceId
                            })
                            
                            if !connectedByUser {
                                integration.connectedByUser = false
                                break
                            }
                        }
                    }
                    self.integrations!.append(integration)
                })
                self.tableView.reloadData()
            })
        }
    }
    
    func setupNavBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = cnGreen
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func showWarning() {
        let warningController = storyboard?.instantiateViewController(withIdentifier: "CNWarning")
        
        warningController?.modalPresentationStyle = .overCurrentContext
        warningController?.modalTransitionStyle = .crossDissolve
        
        present(warningController!, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredIntegrations.count
        }
        if integrations?.count == 0 || integrations == nil {return 0}
        return integrations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNDeviceCell" , for: indexPath) as! CNDeviceCell
        let integration: CNIntegration!
        if isFiltering() {
            integration = filteredIntegrations[indexPath.row]
        } else {
            integration = integrations![indexPath.row]
        }
        
        cell.logoView?.sd_setImage(with: URL(string: integration.iconUrl), completed: nil)
        cell.titleLabel.text = integration.name
        cell.loading.isHidden = true
        cell.loading.hidesWhenStopped = true
        
        if integration.connectedByUser {
            cell.contentLabel.textColor = self.cnGreen
            cell.contentLabel.text = "Já faz parte da sua lista"
            cell.statusIcon.image = UIImage(named: "icon-checked", in: CarenetSDK.shared.bundle, compatibleWith: nil)
            cell.statusIcon.isHidden = false
            cell.accessoryType = .none
        } else {
            cell.contentLabel.textColor = UIColor.darkGray
            cell.contentLabel.text = integration.subtitle
            if integration.devices.count > 1 {
                cell.statusIcon.isHidden = true
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.statusIcon.image = UIImage(named: "icon-add", in: CarenetSDK.shared.bundle, compatibleWith: nil)
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let integration: CNIntegration!
        if isFiltering() {
            integration = filteredIntegrations[indexPath.row]
        } else {
            integration = integrations![indexPath.row]
        }
        
        if !integration.connectedByUser {
            let cell = tableView.cellForRow(at: indexPath) as! CNDeviceCell
            
            if integration.devices.count > 1 {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "CNDevices") as! CNDevicesViewController
                controller.integration = integration
                
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
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
                    for (_, device) in integration.devices.enumerated() {
                        let key = device.key
                        CNDatabase.devicesDatabaseReference(device: key).observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let data = snapshot.value as? [String: Any] else { return }
                            var device = CNDevice(data: data)
                            device.id = key
                            
                            var connection = [String : Any]()
                            switch device.connectionType {
                            case .Bluetooth:
                                connection = [
                                    "deviceId" : device.id!,
                                    "deviceDisplayName" : device.name,
                                    "deviceIconURL" : device.iconUrl,
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
                                break
                            case .Cloud:
//                                let connection = [
//                                    "deviceId" : device.id!,
//                                    "deviceDisplayName" : device.name,
//                                    "deviceIconURL" : device.iconUrl,
//                                    "creationDate" : "",
//                                    "deviceName" : device.name,
//                                    "expirationDate" : "",
//                                    "externalUserId" : "",
//                                    "externalUserSecret" : "",
//                                    "externalUserToken:" : "",
//                                    "lastSyncStatus" : "",
//                                    "lastSyncTime" : ""
//                                    ] as [String : Any]
                                return
                            default:
                                break
                            }
                            
                            CNDatabase.connectionsDatabaseReference().childByAutoId().updateChildValues(connection)
        
                            self.animateCellAndShowMyDevices(cell: cell)

                        })
                    }
                })
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private instance methods
    
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
    
    func filterContentForSearchText(_ searchText: String) {
        filteredIntegrations = self.integrations!.filter({( integration : CNIntegration) -> Bool in
            return integration.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }

}

extension CNIntegrationsViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
}

extension CNIntegrationsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
