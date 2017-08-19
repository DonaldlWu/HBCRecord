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
    
    func checkIsGaming() {
        guard let gamingStatus = UserDefaults.standard.string(forKey: "gaming") else {
            return
        }
        if gamingStatus == "true" {
            getDataFromCoreData()
        } else if gamingStatus == "false" {
            return
        }
    }
    
    func getDataFromCoreData() {
        let appDel = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDel?.persistentContainer.viewContext else { return }
        do {
            let result = try context.fetch(PlayingPlayer.fetchRequest())
            for item in result {
                let thisPlayer = item as? PlayingPlayer
                // Reconstruct by using map
                
                if thisPlayer?.recordArray != nil {
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: (thisPlayer?.recordArray as NSData?)! as Data)
                    let arrayObject = unarchiveObject as AnyObject! as! Array<String>
                    let array = arrayObject
                    self.players.append(Player(mid: thisPlayer?.mid, name: thisPlayer?.name, order: thisPlayer?.order, position: thisPlayer?.position, recordArray: array, profileImage: thisPlayer?.profileImage))
                } else {
                    self.players.append(Player(mid: thisPlayer?.mid, name: thisPlayer?.name, order: thisPlayer?.order, position: thisPlayer?.position, recordArray: [], profileImage: thisPlayer?.profileImage))
                }
            }
        } catch {
            
        }
        if players.count >= 9 {
            goToGameTabBarController()
        } else {
            return
        }
    }
    
    func goToGameTabBarController() {
        let controller = GameTabBarController()
        controller.players = self.players
        present(controller, animated: true, completion: nil)
    }
    
    func fetchTeam() {
        FIRDatabase.database().reference().child("Team").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let team = Team()
                team.tid = snapshot.key
                team.setValuesForKeys(dictionary)
//                team.uid = dictionary["uid"] as? String
//                team.teamName = dictionary["TeamName"] as? String
//                team.teamProfileImageURL = dictionary["teamProfileImageURL"] as? String
                if team.uid == self.user.uid {
                    self.teams.append(team)
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func checkUserIsLogin() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            self.checkIsGaming()
        } else {
            fetchUserSetNavBarTitle()
        }
    }
    
    func fetchUserSetNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("User").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let  dictionary = snapshot.value as? [String: Any] {
                // To reconstruct User(), profileImageURL <--> userProfileImageURL
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
    
    func toMemberController() {
        let alertController = UIAlertController(title: "Add New Team", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            if firstTextField.text! != "" {
                self.showTeamImage(teamName: firstTextField.text!)
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
    
    func showTeamImage(teamName: String) {
        let imageSeloctorController = TeamImageController()
        imageSeloctorController.user = self.user
        imageSeloctorController.teamName = teamName
        show(imageSeloctorController, sender: self)
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
