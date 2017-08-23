//
//  HomeController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/3.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class HomeController: UITableViewController {
    
    let cellId = "cellId"
    var teams = [Team]()
    var user = User()
    var players = [Player]()
    var opponent = [Player]()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TeamCell.self, forCellReuseIdentifier: cellId)
        let newTeamButton = UIBarButtonItem(title: "New Team", style: .plain, target: self, action: #selector(toMemberController))
        navigationItem.rightBarButtonItem = newTeamButton
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = logoutButton
        checkUserIsLogin()
        checkIsGaming()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamCell
        
        cell.teamLabel.text = teams[indexPath.row].teamName
        if let teamProfileImageURL = teams[indexPath.row].teamProfileImageURL {
            cell.profileImageView.loadImageUsingCashWithUrlString(urlString: teamProfileImageURL)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MemberController()
        controller.team = teams[indexPath.row]
        show(controller, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
}
