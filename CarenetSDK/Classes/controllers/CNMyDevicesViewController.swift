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
    @IBOutlet var syncButton: UIButton!
    
    var connections: [CNConnection]!
    private var selectedRows = Set<Int>()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.selectedRows.removeAll()
        self.tableView.reloadData()
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
                cell.isExpanded = false
                
                tableView.beginUpdates()
                tableView.endUpdates()
                
                selectedRows.remove(indexPath.row)
                connections.remove(at: indexPath.row)
                
                if connections.count == 0 {
                    CarenetSDK.shared.showMainViewController()
                    return
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if connections == nil || connections.count == 0 { return 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connections == nil || connections.count == 0 { return 0 }
        return connections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CarenetSDK.shared.bundle.loadNibNamed("MyDevicesHeader", owner: self, options: nil)!.first as! MyDevicesHeader
        let validateString = connections.count > 1 ? "dispositivos" : "dispositivo"
        headerView.devicesCountLabel.text = "Encontramos \(connections.count) \(validateString)!"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNMyDevicesCell" , for: indexPath) as! CNMyDevicesCell
        let connection = connections[indexPath.row]
        
        cell.logoView.sd_setImage(with: URL(string: connection.deviceIconURL), completed: nil)
        cell.titleLabel.text = connection.deviceDisplayName
        cell.contentLabel.text = "Última sincronização \(connection.lastSyncTime)"
        cell.syncButton.addTarget(self, action: #selector(sync(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(removeConnection(_:)), for: .touchUpInside)
        cell.isExpanded = selectedRows.contains(indexPath.row)
 
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) as? CNMyDevicesCell else { return 68 }
        if cell.isExpanded {
            return 118
        }
        
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? CNMyDevicesCell else { return }
        
        switch cell.isExpanded {
        case true:
            self.selectedRows.remove(indexPath.row)
        case false:
            self.selectedRows.insert(indexPath.row)
        }
        
        cell.isExpanded = !cell.isExpanded
        
        if cell.isExpanded {
            cell.performIndicatorAnimation(up: true)
        } else {
            cell.performIndicatorAnimation(up: false)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CNMyDevicesCell else { return }
        cell.isExpanded = false
        cell.performIndicatorAnimation(up: false)
        
        selectedRows.remove(indexPath.row)
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    private var currentAnimationIndex = 0
    
    func getAllCells() -> [CNMyDevicesCell] {
        
        var cells = [CNMyDevicesCell]()
        // assuming tableView is your self.tableView defined somewhere
        for i in 0...tableView.numberOfSections-1
        {
            for j in 0...tableView.numberOfRows(inSection: i)-1
            {
                if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                    
                    cells.append(cell as! CNMyDevicesCell)
                }
            }
        }
        return cells
    }
    
    @IBAction func syncAll(_ sender: UIButton) {
        syncButton.setTitle("Cancelar", for: .normal)
        syncButton.backgroundColor = UIColor.darkGray
        startSync()
    }
    
    func finishSync() {
        syncButton.setTitle("Sincronizar", for: .normal)
        syncButton.backgroundColor = cnGreen
        tableView.reloadData()
    }
    
    func startSync(animationIndex: Int = 0) {
        for (index, cell) in getAllCells().enumerated() {
            UIView.animate(withDuration: 0.3, animations: {
                cell.contentLabel.alpha = 0
            }) { (finished) in
                UIView.animate(withDuration: 0.3, animations: {
                    cell.contentLabel.alpha = 1
                    cell.contentLabel.text = "Em fila..."
                    if index == animationIndex {
                        cell.contentLabel.text = "Sincronizando"
                    }
                })
            }
            
        }
        
        let cell = getAllCells()[animationIndex]
        currentAnimationIndex = animationIndex
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.next()
        })
    }
    
    private func next() {
        let newIndex = self.currentAnimationIndex + 1
        if newIndex < self.getAllCells().count {
            self.startSync(animationIndex: newIndex)
        } else {
            self.finishSync()
        }
    }
}
