//
//  Member.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/17.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class Member: NSObject {
    var mid: String?
    var memberName: String?
    var position: String?
    var mamberProfileImageURL: String?
    var tid: String?
    var memberNumber: String?
    var order: String?
    var lineup = false
    
    func memberToPlayer(member: Member) -> Player {
        let player = Player(mid: nil, name: member.memberName, order: "1", position: "1", recordArray: [], profileImage: member.mamberProfileImageURL)
        return player
    }
}
    
