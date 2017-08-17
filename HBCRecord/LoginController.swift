//
//  LoginController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/12.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class LoginController: AddMemberController {
    
    var homeController: HomeController?
    var profileImageTopAnchor: NSLayoutConstraint?
    var emailTopAnchor: NSLayoutConstraint?
    
    let myIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    
    let loginSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleChangeButtonTitle), for: .valueChanged)
        return sc
    }()
    
    let emailText: UITextField = {
        let text = UITextField()
        text.placeholder = "email"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.borderColor = UIColor.cyan.cgColor
        text.layer.borderWidth = 1
        return text
    }()
    
    let passwordText: UITextField = {
        let text = UITextField()
        text.placeholder = "password"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isSecureTextEntry = true
        text.layer.borderColor = UIColor.cyan.cgColor
        text.layer.borderWidth = 1
        return text
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    func handleLogin() {
        guard let email = emailText.text, let password = passwordText.text else {
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                // Indicator stop
                self.myIndicator.stopAnimating()
                print(error!)
                if let errorMessage = error?.localizedDescription {
                    self.loginFaild(message: errorMessage)
                }
                return
            }
            self.homeController?.fetchUserSetNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func loginFaild(message: String) {
        var popMessage = "登入失敗"
        switch message {
        case "The email address is badly formatted.":
            popMessage = "電子郵件格式錯誤"
        case "The password is invalid or the user does not have a password.":
            popMessage = "密碼錯誤"
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            popMessage = "帳號不存在"
        default:
            return
        }
        let controller = UIAlertController(title: popMessage, message: nil, preferredStyle: .alert)
        let understandButton = UIAlertAction(title: "知道了", style: .default, handler: nil)
        controller.addAction(understandButton)
        self.present(controller, animated: true, completion: nil)
    }
    

    func handleLoginRegister() {
        // Login or Register
        if loginSegmentedControl.selectedSegmentIndex == 0 {
            if emailText.text!.isEmpty || passwordText.text!.isEmpty {
                emailText.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.red])
                passwordText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            } else {
                // Indicator start
                myIndicator.startAnimating()
                handleLogin()
            }
        } else {
            if emailText.text!.isEmpty || passwordText.text!.isEmpty || nameText.text!.isEmpty {
                emailText.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.red])
                passwordText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.red])
                nameText.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            } else {
                // Indicator start
                myIndicator.startAnimating()
                handleRegister()
            }
        }
    }
    
    func handleRegister() {
        guard let email = emailText.text, let password = passwordText.text, let name = nameText.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                if let errorMessage = error?.localizedDescription {
                    self.loginFaild(message: errorMessage)
                }
                // indicator stop
                self.myIndicator.stopAnimating()
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("userProfile_images").child("\(imageName).jpg")
            if let uploadImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.1) {
                storageRef.put(uploadImage, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let accountValue = ["email": email, "name": name, "userProfileImageURL": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, accountValue: accountValue)
                    }
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, accountValue: [String: Any] ) {
        let ref = FIRDatabase.database().reference(fromURL: "https://hbcrecord-5a3d4.firebaseio.com/")
        let userReference = ref.child("User").child(uid)
        userReference.updateChildValues(accountValue, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
//            self.homeController?.navigationItem.title = accountValue["name"] as? String
            self.homeController?.fetchUserSetNavBarTitle()
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func handleChangeButtonTitle() {
        if loginSegmentedControl.selectedSegmentIndex == 0 {
            loginButton.setTitle("Login", for: .normal)
            nameText.isHidden = true
            profileImageTopAnchor?.constant = 64
            emailTopAnchor?.constant = 8
        } else {
            loginButton.setTitle("Register", for: .normal)
            nameText.isHidden = false
            profileImageTopAnchor?.constant = 32
            emailTopAnchor?.constant = 48
            view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add subView & Layout
        profileImage.removeFromSuperview()
        profileImage.removeConstraints(profileImage.constraints)
        positionSegmentedControl.removeFromSuperview()
        nameText.removeFromSuperview()
        numberText.removeFromSuperview()
        registerButton.removeFromSuperview()
        
        view.addSubview(profileImage)
        view.addSubview(loginSegmentedControl)
        view.addSubview(nameText)
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(loginButton)
        view.addSubview(myIndicator)
        nameText.isHidden = true
        
        profileImageTopAnchor = profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 64)
        profileImageTopAnchor?.isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        loginSegmentedControl.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        loginSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        loginSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        loginSegmentedControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameText.topAnchor.constraint(equalTo: loginSegmentedControl.bottomAnchor, constant: 8).isActive = true
        nameText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        nameText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true

        
        emailTopAnchor = emailText.topAnchor.constraint(equalTo: loginSegmentedControl.bottomAnchor, constant: 8)
        emailTopAnchor?.isActive = true
        emailText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        emailText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        emailText.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        passwordText.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 8).isActive = true
        passwordText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        passwordText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        passwordText.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 8).isActive = true
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        myIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        myIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        myIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }

}
