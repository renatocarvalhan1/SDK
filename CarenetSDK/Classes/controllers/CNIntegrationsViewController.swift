//
//  CNIntegrationsViewController.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit
import FirebaseCommunity

class CNIntegrationsViewController: CNBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
     override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        tableView.register(UINib(nibName: "CNDeviceCell", bundle: CarenetSDK.shared.bundle), forCellReuseIdentifier: "CNDeviceCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func loadIntegrations() {
//        CNDatabase.integrationDatabaseReference().observe(.value, with:{(snapshot) in
//            var devices = [CNIntegration]()
//            for itemSnapShot in snapshot.children {
//                let fp = In(snapshot: itemSnapShot as! DataSnapshot)
//                newPosts.append(fp!)
//            }
//            self.feedPosts = newPosts.reversed()
//            self.tableView.reloadData()
//            if self.feedPosts!.count == 0 {
//                self.noContentLabel.isHidden = false;
//            }else{
//                self.noContentLabel.isHidden = true;
//            }
//        })
    }
    
    func setupNavBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            let searchController = UISearchController.init(searchResultsController: nil)
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let warningController = storyboard?.instantiateViewController(withIdentifier: "CNWarningSync") as! CNWarningSyncViewController

        warningController.modalPresentationStyle = .overCurrentContext
        warningController.modalTransitionStyle = .crossDissolve

        present(warningController, animated: true, completion: nil)
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
