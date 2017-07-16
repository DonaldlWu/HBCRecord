//
//  HomeController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/3.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UITableViewController {
    
    let cellId = "cellId"
    var teams = [Team]()
    var user = User()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TeamCell.self, forCellReuseIdentifier: cellId)
        let newTeamButton = UIBarButtonItem(title: "New Team", style: .plain, target: self, action: #selector(toSetNewTeamController))
        navigationItem.rightBarButtonItem = newTeamButton
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = logoutButton
        checkUserIsLogin()
    }
    
    func fetchTeam() {
        FIRDatabase.database().reference().child("Team").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let team = Team()
                team.setValuesForKeys(dictionary)
                if team.uid == self.user.uid {
                    self.teams.append(team)
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(team.teamName as Any, team.uid as Any)
            }
        }, withCancel: nil)
    }
    
    func checkUserIsLogin() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserSetNavBarTitle()
        }
    }
    
    func fetchUserSetNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("User").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let  dictionary = snapshot.value as? [String: Any] {
                // because uid is not in dictionary, so we can't directly update user's data by setValesForKeys, it will crash
                // self.user.setValuesForKeys(dictionary)
                self.user.name = dictionary["name"] as? String
                self.user.email = dictionary["email"] as? String
                self.user.uid = snapshot.key
                self.user.profileImageURL = dictionary["userProfileImageURL"] as? String
                self.setupNavBarWithUser(user: self.user)
                self.fetchTeam()
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageURL = user.profileImageURL {
            profileImageView.loadImageUsingCashWithUrlString(urlString: profileImageURL)
        }
        
        containerView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        self.teams.removeAll()
        self.user.clearAll()
        let loginController = LoginController()
        loginController.homeController = self
        present(loginController, animated: true, completion: nil)
    }
    
    func toSetNewTeamController() {
        let alertController = UIAlertController(title: "Add New Team", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let controller = SetNewTeamController()
            let imageSeloctorController = TeamImageController()
            
            if firstTextField.text! != "" {
                controller.teamTitle = firstTextField.text!
                imageSeloctorController.user = self.user
                imageSeloctorController.teamName = firstTextField.text!
                self.present(UINavigationController(rootViewController: imageSeloctorController), animated: true, completion: nil)
            } else {
                return
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Team Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
        let controller = SetNewTeamController()
        controller.teamTitle = teams[indexPath.row].teamName
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
