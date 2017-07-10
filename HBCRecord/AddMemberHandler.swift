//
//  AddMemberHandler.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/10.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

extension AddMemberController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleChangeImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
}
