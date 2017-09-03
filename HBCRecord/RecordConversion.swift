//
//  RecordConversion.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/8/17.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import Foundation

func recordConversion(player: Player) -> Dictionary<String, Any>{
    var recordDict: Dictionary<String, Any> = [:]
    var PA = Double(player.recordArray.count)
    var AB = Double(player.recordArray.count)
    var R = 0
    var RBI = 0
    var H = 0.00
    var E = 0
    player.recordArray.forEach { (result) in
        if let string = result {
            switch string {
            case "(R)":
                PA = PA - 1
                AB = AB - 1
                R = R + 1
            case "1RBI", "2RBI", "3RBI", "4RBI":
                PA = PA - 1
                AB = AB - 1
                RBI = RBI + 1
            case "SF", "SH", "BB", "HBP":
                AB = AB - 1
            case "H", "2B", "3B", "HR":
                H = H + 1
            case "E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9":
                E = E + 1
            default:
                print("")
            }
        }
    }
    let AVG = H / AB
    let HforRecord = Int(H)
    recordDict.updateValue(AVG, forKey: "AVG")
    recordDict.updateValue(PA, forKey: "PA")
    recordDict.updateValue(AB, forKey: "AB")
    recordDict.updateValue(HforRecord, forKey: "H")
    recordDict.updateValue(R, forKey: "R")
    recordDict.updateValue(RBI, forKey: "RBI")
    recordDict.updateValue(E, forKey: "E")
    return recordDict
}
