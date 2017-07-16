//
//  SetNewTeamController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/5.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class SetNewTeamController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    var teamTitle: String?
    var team = Team()
    var members = [Member]()
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
        print(self.team)
        
        let backButton = UIBarButtonItem(title: "BACK", style: .done, target: self, action: #selector(backHome))
        let addButton = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(toAddMemberController))
        navigationItem.title = self.team.teamName
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
        
        fetchMember()

    }
    
    func fetchMember() {
        FIRDatabase.database().reference().child("Member").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let member = Member()
                member.setValuesForKeys(dictionary)
                if member.tid == self.team.tid {
                    self.members.append(member)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func backHome() {
        let controller = HomeController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func toAddMemberController() {
        let controller = AddMemberController()
        controller.team = self.team
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
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MemberCell
        cell.nameLabel.text = members[indexPath.row].memberName
        if let memberProfileImageURL = members[indexPath.row].mamberProfileImageURL {
            cell.profileImageView.loadImageUsingCashWithUrlString(urlString: memberProfileImageURL)
        }
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

    

