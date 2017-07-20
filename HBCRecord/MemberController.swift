//
//  MemberController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/5.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class MemberController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let orderArray = ["一棒", "二棒", "三棒", "四棒", "五棒", "六棒", "七棒", "八棒", "九棒"]
    var players = [Player]()
    var members = [Member]()
    var teamTitle: String?
    var team = Team()
    let cellId = "cellId"
    var refreshControl:UIRefreshControl!
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
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView!.addSubview(refreshControl)
        tableView.register(MemberCell.self, forCellReuseIdentifier: cellId)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view.addSubview(startButton)
        setUpConstraint()
        fetchMember()
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? MemberCell
        
        let cancel = UITableViewRowAction(style: .normal, title: "Cancel") { action, index in
            self.members[indexPath.row].lineup = false
            self.members[indexPath.row].order = nil
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            self.tableView?.isEditing = false
        }
        cancel.backgroundColor = .red
        
        let checkLineup = UITableViewRowAction(style: .normal, title: "Line Up") { action, index in
            let tempPlayer = Player(name: cell?.nameLabel.text, order: "", position: cell?.lineupSelectButton.titleLabel?.text, recordArray: [], profileImage: cell?.detailTextLabel?.text)
            self.lineupOrderSet(indexPath: indexPath, tempPlayer: tempPlayer)
            self.tableView?.isEditing = false
        }
        checkLineup.backgroundColor = .cyan
        
        return [cancel, checkLineup]
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
        let orderNumberArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
        let alertController = UIAlertController(title: "Order", message: nil, preferredStyle: .actionSheet)
        for order in orderNumberArray {
            let order = UIAlertAction(title: orderArray[Int(order)!], style: .default, handler: {
                alert -> Void in
                
                if self.players.count == 9 {
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = .cyan
                } else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = .gray
                    var addPlayer = tempPlayer
                    addPlayer.order = order
                    self.recoderAssign(order: Int(order)!, addPlayer: addPlayer)
                    self.members[indexPath.row].lineup = true
                    self.members[indexPath.row].order = order
                    
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
        controller.players = self.players
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
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
    
}

    

