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
    let searchController = UISearchController.init(searchResultsController: nil)
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CNDeviceCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNDeviceCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupNavBar()
        showWarning()
        loadIntegrations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func loadIntegrations() {
        var array = [CNIntegration]()
        CNDatabase.integrationDatabaseReference().observe(.value, with:{(snapshot) in
            for itemSnapShot in snapshot.children {
                let i = CNIntegration(snapshot: itemSnapShot as! DataSnapshot)
                array.append(i!)
            }
            self.integrations = array
            self.tableView.reloadData()
        })
    }
    
    func setupNavBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
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
    
    @objc func add(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? CNDeviceCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.addButton.alpha = 0
                cell.loading.alpha = 1
                cell.loading.isHidden = false
                cell.loading.startAnimating()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.contentLabel.alpha = 0
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.loading.isHidden = true
                        cell.loading.hidesWhenStopped = true
                        cell.loading.alpha = 0
                        cell.addButton.alpha = 1
                        cell.contentLabel.alpha = 1
                        cell.contentLabel.textColor = self.paGreen
                        cell.contentLabel.text = "Já faz parte da sua lista"
                        cell.addButton.setImage(UIImage.init(named: "icon-checked", in: CarenetSDK.shared.bundle, compatibleWith: nil), for: .normal)
                        
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
        
        cell.logoView?.sd_setImage(with: URL.init(string: integration.iconUrl!), completed: nil)
        cell.titleLabel.text = integration.name
        cell.contentLabel.textColor = UIColor.darkGray
        cell.contentLabel.text = integration.devices!.count > 1 ? "Todos os dispositivos" : integration.dbId
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
        let integration: CNIntegration!
        if isFiltering() {
            integration = filteredIntegrations[indexPath.row]
        } else {
            integration = integrations![indexPath.row]
        }
        
        if integration.devices!.count > 1 {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CNDevices") as! CNDevicesViewController
            controller.integrationName = integration.dbId
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String) {
        filteredIntegrations = self.integrations!.filter({( integration : CNIntegration) -> Bool in
            return integration.name!.lowercased().contains(searchText.lowercased())
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
