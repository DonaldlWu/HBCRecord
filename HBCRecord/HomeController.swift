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
                self.navigationItem.title = dictionary["name"] as? String
            }
        }, withCancel: nil)
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
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
            
            if firstTextField.text! != "" {
                controller.teamTitle = firstTextField.text!
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.textLabel?.text = "TEAM LIST HERE"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SetNewTeamController()
        controller.teamTitle = "Exit Team Name\(indexPath.row)"
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
}
