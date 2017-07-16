//
//  SetNewTeamController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/5.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class SetNewTeamController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    var teamTitle: String?
    private var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(toRecordController), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let backButton = UIBarButtonItem(title: "BACK", style: .done, target: self, action: #selector(backHome))
        let addButton = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(toAddMemberController))
        navigationItem.title = teamTitle
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = addButton
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(startButton)
        
        tableView.register(MemberCell.self, forCellReuseIdentifier: cellId)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        
        startButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

    }
    
    func backHome() {
        let controller = HomeController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func toAddMemberController() {
        let controller = AddMemberController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func toRecordController() {
        let controller = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MemberCell
        cell.nameLabel.text = "MEMBER HERE"
        cell.AVGLabel.text = "AVG: .350"
        cell.OBPLabel.text = "OBP: .447"
        cell.SLGLabel.text = "SLG: .458"
        cell.OPSLabel.text = "OPS: .819"
        if indexPath.row == 3 {
            cell.backgroundColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

    

