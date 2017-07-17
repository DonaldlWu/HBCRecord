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
    var lineUp = [Member]()
    var refreshControl:UIRefreshControl!
    private var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func refresh(sender:AnyObject)
    {
        
        let alertController = UIAlertController(title: "Sort By", message: "", preferredStyle: .actionSheet)
        
        let numberSort = UIAlertAction(title: "Number", style: .default, handler: {
            alert -> Void in
            DispatchQueue.main.async {
                self.members.sort(by: { (first: Member , second: Member) -> Bool in
                    Int(first.memberNumber!)! < Int(second.memberNumber!)!
                })
                self.tableView?.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
        
        let testSort = UIAlertAction(title: "unNumber", style: .default, handler: {
            alert -> Void in
            DispatchQueue.main.async {
                self.members.sort(by: { (first: Member , second: Member) -> Bool in
                    Int(first.memberNumber!)! > Int(second.memberNumber!)!
                })
                self.tableView?.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
        
        alertController.addAction(numberSort)
        alertController.addAction(testSort)
        self.present(alertController, animated: true, completion: nil)
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
        let controller = RecordController()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        startButton.isEnabled = false
        startButton.backgroundColor = .gray
        
        let backButton = UIBarButtonItem(title: "BACK", style: .done, target: self, action: #selector(backHome))
        let addButton = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(toAddMemberController))
        navigationItem.title = self.team.teamName
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = addButton
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(startButton)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView!.addSubview(refreshControl)
        
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
        controller.lineUp = self.lineUp
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
        cell.lineupSelectButton.setTitle(members[indexPath.row].position, for: .normal)
        cell.lineupSelectButton.tag = indexPath.row
        cell.lineupSelectButton.addTarget(self, action: #selector(linupSet(sender:)), for: .touchUpInside)
        cell.numberLabel.text = members[indexPath.row].memberNumber
        cell.AVGLabel.text = "AVG: .350"
        cell.OBPLabel.text = "OBP: .447"
        cell.SLGLabel.text = "SLG: .458"
        cell.OPSLabel.text = "OPS: .819"
        return cell
    }
    
    func linupSet(sender: UIButton) {
        
        let positionArray = ["P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF"]
        let alertController = UIAlertController(title: "Position", message: "", preferredStyle: .actionSheet)
        
        for position in positionArray {
            let position = UIAlertAction(title: position, style: .default, handler: {
                alert -> Void in
                self.members[sender.tag].position = position
                let indexPath = IndexPath(item: sender.tag, section: 0)
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            })
            alertController.addAction(position)
        }
        
        let cancelButtonAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel) {
            action in
        }
        
        alertController.addAction(cancelButtonAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lineUp.append(members[indexPath.row])
        
        if lineUp.count == 9 {
            startButton.isEnabled = true
            startButton.backgroundColor = .purple
        } else {
            startButton.isEnabled = false
            startButton.backgroundColor = .gray
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

    

