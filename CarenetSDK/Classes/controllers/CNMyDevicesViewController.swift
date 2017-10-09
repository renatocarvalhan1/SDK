//
//  CNMyDevicesViewController.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit

class CNMyDevicesViewController: CNBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var selectedIndexPath: IndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CNMyDevicesCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNMyDevicesCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNMyDevicesCell" , for: indexPath) as! CNMyDevicesCell
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
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
}
