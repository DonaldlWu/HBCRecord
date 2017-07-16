//
//  User.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/15.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    var profileImageURL: String?
    var uid: String?
    
    func clearAll() {
        name?.removeAll()
        email?.removeAll()
        profileImageURL?.removeAll()
        uid?.removeAll()
    }
    
}
