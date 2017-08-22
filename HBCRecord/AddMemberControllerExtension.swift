//
//  AddMemberControllerExtension.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/8/20.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

extension AddMemberController {
    
    func backMemberController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        NotificationCenter.default.addObserver(self, selector: #selector(changekeyboardSizeValue), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func registerNewPlayer() {
        if nameText.text != "" && numberText.text != "" {
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
                        let value: [AnyHashable: Any] = ["memberName": self.nameText.text as Any, "position": self.positionArray[self.positionSegmentedControl.selectedSegmentIndex], "memberNumber": self.numberText.text as Any, "tid": self.team.tid as Any, "mamberProfileImageURL": profileImageURL]
                        memberRef.updateChildValues(value)
                    }
                })
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func backHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
//    func changekeyboardSizeValue(notification: NSNotification) {
//        if UIDevice.current.orientation != .portrait {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y != 0 {
//                    self.view.frame.origin.y += keyboardSize.height
//                } else {
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//            }
//        }
//    }
    
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
