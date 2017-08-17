//
//  Player.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/6/27.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

var recordArray0:Array<String> = []
var recordArray1:Array<String> = []
var recordArray2:Array<String> = []
var recordArray3:Array<String> = []
var recordArray4:Array<String> = []
var recordArray5:Array<String> = []
var recordArray6:Array<String> = []
var recordArray7:Array<String> = []
var recordArray8:Array<String> = []

struct Player {
    var mid: String?
    var name: String?
    var order: String?
    var position: String?
    var recordArray: Array<String?>
    var profileImage: String?
}

//extension Player {
//    init?(data: NSData) {
//        if let coding = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Encoding {
//            name = coding.name as String?
//            order = coding.order as String?
//            position = coding.position as String?
//            recordArray = coding.recordArray as Array<String?>
//            profileImage = coding.profileImage as String?
//        } else {
//            return nil
//        }
//    }
//    
//    func encode() -> NSData {
//        return NSKeyedArchiver.archivedData(withRootObject: Encoding(self)) as NSData
//    }
//    
//    private class Encoding: NSObject, NSCoding {
//        let name : NSString?
//        let order : NSString?
//        let position : NSString?
//        let recordArray: Array<String?>
//        let profileImage: NSString?
//        
//        init(_ Player: Player) {
//            name = Player.name as NSString?
//            order = Player.order as NSString?
//            position = Player.position as NSString?
//            recordArray = (Player.recordArray as NSArray) as! Array<String?>
//            profileImage = Player.profileImage as NSString?
//        }
//        
//        @objc required init?(coder aDecoder: NSCoder) {
//            name = aDecoder.decodeObject(forKey: "name") as? NSString
//            order = aDecoder.decodeObject(forKey: "order") as? NSString
//            position = aDecoder.decodeObject(forKey: "position") as? NSString
//            recordArray = aDecoder.decodeObject(forKey: "recordArray") as? NSArray as! Array<String?>
//            profileImage = aDecoder.decodeObject(forKey: "profileImage") as? NSString
//            
//        }
//        
//        @objc func encode(with aCoder: NSCoder) {
//            aCoder.encode(name, forKey: "name")
//            aCoder.encode(order, forKey: "order")
//            aCoder.encode(position, forKey: "position")
//            aCoder.encode(recordArray, forKey: "recordArray")
//            aCoder.encode(profileImage, forKey: "profileImage")
//            
//        }
//    }
//
//}
