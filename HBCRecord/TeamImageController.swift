//
//  TeamImageController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/16.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class TeamImageController: AddMemberController {
    
    var user = User()
    var teamName: String?
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(handleAddNewTeam), for: .touchUpInside)
        return button
    }()
    
    func handleAddNewTeam() {
        let ref = FIRDatabase.database().reference().child("Team")
        let teamRef = ref.childByAutoId()
        let tid = teamRef.key
        let controller = SetNewTeamController()
        controller.team.teamName = teamName
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("teamProfile_images").child("\(imageName).jpg")
        if let uploadImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.1) {
            storageRef.put(uploadImage, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let value: [AnyHashable: Any] = ["TeamName": self.teamName as Any, "uid": self.user.uid as Any, "teamProfileImageURL": profileImageURL, "tid": tid]
                    teamRef.updateChildValues(value)
                }
            })
        }
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.removeFromSuperview()
        profileImage.removeConstraints(profileImage.constraints)
        positionSegmentedControl.removeFromSuperview()
        nameText.removeFromSuperview()
        registerButton.removeFromSuperview()
        
        view.addSubview(profileImage)
        view.addSubview(addButton)
        
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 220).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        addButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12).isActive = true
        addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
