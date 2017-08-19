//
//  MemberControllerExtension.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/8/20.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

extension MemberController {
    
    func registerTableViewAndRefreshControl() {
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView!.addSubview(refreshControl)
        tableView.register(MemberCell.self, forCellReuseIdentifier: cellId)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view.addSubview(startButton)
        
    }
    
    func toAddMemberController() {
        let controller = AddMemberController()
        controller.team = self.team
        //show(controller, sender: self)
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func toRecordController() {
        let controller = GameTabBarController()
        controller.players = self.players
        present(controller, animated: true, completion: nil)
    }
    
    func recoderAssign(order: Int, addPlayer: Player) {
        var player = addPlayer
        switch order {
        case 0:
            player.recordArray = recordArray0
        case 1:
            player.recordArray = recordArray1
        case 2:
            player.recordArray = recordArray2
        case 3:
            player.recordArray = recordArray3
        case 4:
            player.recordArray = recordArray4
        case 5:
            player.recordArray = recordArray5
        case 6:
            player.recordArray = recordArray6
        case 7:
            player.recordArray = recordArray7
        case 8:
            player.recordArray = recordArray8
        default:
            return
        }
        self.players.append(player)
    }
    
    func setUpConstraint() {
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        startButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func lineupCancel(indexPath: IndexPath, name: String) {
        if self.players.count != 0 {
            var deleteNumber = 0
            for i in 0...self.players.count - 1 {
                if self.players[i].name == name {
                    deleteNumber = i
                }
            }
            if deleteNumber != 0 {
                self.players.remove(at: deleteNumber)
                if self.players.count != 9 {
                    startButton.isEnabled = false
                    startButton.backgroundColor = .gray
                }
            }
        }
        self.members[indexPath.row].lineup = false
        self.members[indexPath.row].order = nil
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func fetchMember() {
        FIRDatabase.database().reference().child("Member").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let member = Member()
                member.setValuesForKeys(dictionary)
                member.mid = snapshot.key
                if member.tid == self.team.tid {
                    self.members.append(member)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    // fake data ---------------------------------
//                    for i in 0...8 {
//                        let member = Member()
//                        let player = member.memberToPlayer(member: self.members[i])
//                        self.players.append(player)
//                    }
//                    self.startButton.isEnabled = true
//                    self.startButton.backgroundColor = .cyan
//                    /// fake data ---------------------------------
                }
            }
        }, withCancel: nil)
    }
    
    func refresh(sender:AnyObject)
    {
        let alertController = UIAlertController(title: nil, message: "Sort By", preferredStyle: .actionSheet)
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
        
        let unNumber = UIAlertAction(title: "UnNumber", style: .default, handler: {
            alert -> Void in
            DispatchQueue.main.async {
                self.members.sort(by: { (first: Member , second: Member) -> Bool in
                    Int(first.memberNumber!)! > Int(second.memberNumber!)!
                })
                self.tableView?.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
        
        let order = UIAlertAction(title: "order", style: .default, handler: {
            alert -> Void in
            DispatchQueue.main.async {
                
                self.members.sort(by: { (first: Member , second: Member) -> Bool in
                    Int(first.memberNumber!)! < Int(second.memberNumber!)!
                })
                
                self.members.sort(by: { (first: Member , second: Member) -> Bool in
                    Int(first.order ?? "\(self.members.count + 10)")! < Int(second.order ?? "\(self.members.count + 10)")!
                })
                self.tableView?.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
        
        alertController.addAction(numberSort)
        alertController.addAction(unNumber)
        alertController.addAction(order)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func linupPositionSet(sender: UIButton) {
        
        let positionArray = ["DH", "P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF"]
        let alertController = UIAlertController(title: "Position", message: nil, preferredStyle: .actionSheet)
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
    
    func lineupOrderSet(indexPath: IndexPath, tempPlayer: Player) {
        let alertController = UIAlertController(title: "Order", message: nil, preferredStyle: .actionSheet)
        for order in orderNumberArray {
            let order = UIAlertAction(title: orderArray[Int(order)!], style: .default, handler: {
                alert -> Void in
                
                // Before user choice order
                if self.players.count == 9 {
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = .cyan
                } else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = .gray
                    var addPlayer = tempPlayer
                    addPlayer.mid = self.members[indexPath.row].mid
                    addPlayer.order = order
                    self.recoderAssign(order: Int(order)!, addPlayer: addPlayer)
                    self.members[indexPath.row].lineup = true
                    self.members[indexPath.row].order = order
                }
                
                // After user choice order
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    if self.players.count == 9 {
                        self.startButton.isEnabled = true
                        self.startButton.backgroundColor = .cyan
                    } else {
                        self.startButton.isEnabled = false
                        self.startButton.backgroundColor = .gray
                    }
                }
            })
            alertController.addAction(order)
        }
        
        let cancelButtonAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel) {
            action in
        }
        
        alertController.addAction(cancelButtonAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
