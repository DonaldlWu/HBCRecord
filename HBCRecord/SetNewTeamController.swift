//
//  SetNewTeamController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/5.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class SetNewTeamController: UITableViewController {
    
    let cellId = "cellId"
    var teamTitle: String?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = teamTitle
        
        let backButton = UIBarButtonItem(title: "BACK",
                                         style: .done, target: self, action: #selector(backHome))
        navigationItem.leftBarButtonItem = backButton
        
        let startButton = UIBarButtonItem(title: "START",
                                         style: .plain, target: self, action: #selector(toRecordController))
        navigationItem.rightBarButtonItem = startButton
        
        
    }
    
    func backHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func toRecordController() {
        let controller = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = "MEMBER HERE"
        return cell
    }
    
}
