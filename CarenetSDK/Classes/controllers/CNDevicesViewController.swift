//
//  CNDevicesViewController.swift
//  Pods
//
//  Created by Renato Carvalhan on 03/10/17.
//
//

import UIKit

class CNDevicesViewController: CNBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CNDeviceCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNDeviceCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let warningController = storyboard?.instantiateViewController(withIdentifier: "CNWarningSync") as! CNWarningSyncViewController
//
//        warningController.modalPresentationStyle = .overCurrentContext
//        warningController.modalTransitionStyle = .crossDissolve
//
//        present(warningController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNDeviceCell" , for: indexPath) as! CNDeviceCell
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
