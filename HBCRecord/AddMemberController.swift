//
//  AddMemberController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/8.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class AddMemberController: UIViewController {
    
    let positionArray = ["P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF"]
    var team = Team()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "pied piper")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangeImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var positionSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let nameText: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Name"
        text.layer.borderColor = UIColor.cyan.cgColor
        text.layer.borderWidth = 1
        return text
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(registerNewPlayer), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let backButton = UIBarButtonItem(title: "BACK", style: .done, target: self, action: #selector(backHome))
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(profileImage)
        view.addSubview(positionSegmentedControl)
        view.addSubview(nameText)
        view.addSubview(registerButton)
        
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        positionSegmentedControl.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 28).isActive = true
        positionSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        positionSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        positionSegmentedControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameText.topAnchor.constraint(equalTo: positionSegmentedControl.bottomAnchor, constant: 12).isActive = true
        nameText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameText.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameText.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 8).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(changekeyboardSizeValue), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func registerNewPlayer() {
        
        let ref = FIRDatabase.database().reference().child("Member")
        let memberRef = ref.childByAutoId()
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("playerProfile_images").child("\(imageName).jpg")
        if let uploadImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.1) {
            storageRef.put(uploadImage, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let value: [AnyHashable: Any] = ["memberName": self.nameText.text as Any, "position": self.positionArray[self.positionSegmentedControl.selectedSegmentIndex], "tid": self.team.tid as Any, "mamberProfileImageURL": profileImageURL]
                    memberRef.updateChildValues(value)
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func backHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func changekeyboardSizeValue(notification: NSNotification) {
        if UIDevice.current.orientation != .portrait {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardSize.height
                } else {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        if UIDevice.current.orientation != .portrait {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
}
