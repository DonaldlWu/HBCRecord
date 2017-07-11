//
//  AddMemberController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/8.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class AddMemberController: UIViewController {
    
    let positionArray = ["P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF"]
    
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
    
    let positionSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let nameText: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Input Name"
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
        NotificationCenter.default.addObserver(self, selector: #selector(AddMemberController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddMemberController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        nameText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 8).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func registerNewPlayer() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func backHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if UIDevice.current.orientation != .portrait {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if UIDevice.current.orientation != .portrait {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
}
