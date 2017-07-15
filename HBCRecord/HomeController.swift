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
            if let dictionary = snapshot.value as? [String: Any] {
                self.user.uid = snapshot.key
                self.navigationItem.title = dictionary["name"] as? String
                self.fetchTeam()
            }
        }, withCancel: nil)
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        self.teams.removeAll()
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
                imageSeloctorController.uid = self.user.uid
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.textLabel?.text = teams[indexPath.row].teamName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SetNewTeamController()
        controller.teamTitle = teams[indexPath.row].teamName
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
}
