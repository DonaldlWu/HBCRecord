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
        image.image = #imageLiteral(resourceName: "HBC")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangeImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var positionSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: self.positionArray)
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
    
    let numberText: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "No"
        text.textAlignment = .center
        text.keyboardType = .numberPad
        text.layer.borderColor = UIColor.cyan.cgColor
        text.layer.borderWidth = 5
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
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(backMemberController))
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = .white
               
        view.addSubview(profileImage)
        view.addSubview(numberText)
        view.addSubview(positionSegmentedControl)
        view.addSubview(nameText)
        view.addSubview(registerButton)
        
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        numberText.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        numberText.bottomAnchor.constraint(equalTo: positionSegmentedControl.topAnchor).isActive = true
        numberText.widthAnchor.constraint(equalToConstant: 48).isActive = true
        numberText.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true

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
    
}
