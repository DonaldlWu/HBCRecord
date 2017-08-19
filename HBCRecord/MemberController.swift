//
//  MemberController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/5.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

let orderArray = ["一棒", "二棒", "三棒", "四棒", "五棒", "六棒", "七棒", "八棒", "九棒"]

class MemberController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orderNumberArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    var players = [Player]()
    var members = [Member]()
    var teamTitle: String?
    var team = Team()
    let cellId = "cellId"
    var refreshControl: UIRefreshControl!
    var tableView: UITableView!
    
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
        let controller = RecordController()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let addButton = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(toAddMemberController))
        navigationItem.title = self.team.teamName
        navigationItem.rightBarButtonItem = addButton
        
        registerTableViewAndRefreshControl()
        setUpConstraint()
        fetchMember()

    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? MemberCell
        
        let cancel = UITableViewRowAction(style: .normal, title: "Cancel") { action, index in
            self.lineupCancel(indexPath: indexPath, name: (cell?.nameLabel.text)!)
            self.tableView?.isEditing = false
        }
        cancel.backgroundColor = .red

        let checkLineup = UITableViewRowAction(style: .normal, title: "Line Up") { action, index in
            let tempPlayer = Player(mid: nil, name: cell?.nameLabel.text, order: "", position: cell?.lineupSelectButton.titleLabel?.text, recordArray: [], profileImage: cell?.detailTextLabel?.text)
            if cell?.lineupLabel.isHidden == true {
                self.lineupOrderSet(indexPath: indexPath, tempPlayer: tempPlayer)
            } else {
                self.lineupCancel(indexPath: indexPath, name: (cell?.nameLabel.text)!)
                self.lineupOrderSet(indexPath: indexPath, tempPlayer: tempPlayer)
            }
            self.tableView?.isEditing = false
        }
        checkLineup.backgroundColor = .cyan
        
        return [cancel, checkLineup]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MemberCell
        cell.nameLabel.text = members[indexPath.row].memberName
        
        if let memberProfileImageURL = members[indexPath.row].mamberProfileImageURL {
            cell.profileImageView.loadImageUsingCashWithUrlString(urlString: memberProfileImageURL)
            // For order select
            cell.detailTextLabel?.text = memberProfileImageURL
            cell.detailTextLabel?.isHidden = true
        }
        
        cell.lineupSelectButton.setTitle(members[indexPath.row].position, for: .normal)
        cell.lineupSelectButton.tag = indexPath.row
        cell.lineupSelectButton.addTarget(self, action: #selector(linupPositionSet(sender:)), for: .touchUpInside)
        cell.numberLabel.text = members[indexPath.row].memberNumber
        if self.members[indexPath.row].lineup == true {
            cell.lineupLabel.isHidden = false
            cell.lineupLabel.text = orderArray[Int(members[indexPath.row].order!)!]
        } else {
            cell.lineupLabel.isHidden = true
        }
        cell.AVGLabel.text = "AVG: .350"
        cell.OBPLabel.text = "OBP: .447"
        cell.SLGLabel.text = "SLG: .458"
        cell.OPSLabel.text = "OPS: .819"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}



