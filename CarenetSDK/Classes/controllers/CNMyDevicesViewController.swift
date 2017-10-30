//
//  CNMyconnectionsViewController.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit
import FirebaseCommunity

class CNMyDevicesViewController: CNBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var connections: [CNConnection]!
    
    private var selectedIndexPath: IndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CNMyDevicesCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNMyDevicesCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadConnections()
    }
    
    func loadConnections() {
        connections = [CNConnection]()
        
        CNDatabase.connectionsDatabaseReference().observeSingleEvent(of: .value, with: { (snapshot) in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var connection = CNConnection(data: dictionary)
                connection.dbId = snapshot.key
                self.connections.append(connection)
            })
            self.tableView.reloadData()
        })
    }
    
    @objc func sync(_ sender: UIButton) {
        if let cell = sender.superview?.superview?.superview as? CNMyDevicesCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let connection = connections[indexPath.row]
                let warningSyncController = storyboard?.instantiateViewController(withIdentifier: "CNWarningSync") as! CNWarningSyncViewController
                warningSyncController.connection = connection
                warningSyncController.modalPresentationStyle = .overCurrentContext
                warningSyncController.modalTransitionStyle = .crossDissolve
                
                present(warningSyncController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func removeConnection(_ sender: UIButton) {
        if let cell = sender.superview?.superview?.superview as? CNMyDevicesCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let connection = connections[indexPath.row]
                CNDatabase.connectionsDatabaseReference().child(connection.dbId!).removeValue()
                
                connections.remove(at: indexPath.row)
                
                selectedIndexPath = nil
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                if connections.count == 0 {
                    CarenetSDK.shared.showMainViewController()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connections == nil || connections.count == 0 { return 0 }
        return connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNMyDevicesCell" , for: indexPath) as! CNMyDevicesCell
        let connection = connections[indexPath.row]
        
        cell.logoView.sd_setImage(with: URL(string: connection.deviceIconURL), completed: nil)
        cell.titleLabel.text = connection.deviceDisplayName
        cell.contentLabel.text = "Última sincronização \(connection.lastSyncTime)"
        cell.syncButton.addTarget(self, action: #selector(sync(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(removeConnection(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath
        
        if selectedIndexPath != nil {
            if index ==  selectedIndexPath {
                return 118
            }
        }
        
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedIndexPath {
        case nil:
            selectedIndexPath = indexPath
        default:
            if selectedIndexPath == indexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
}
