//
//  CoreDataFunction.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/8/23.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import CoreData

// Protocol to reconstrust?
func saveToCoreData(players: [Player], dataType: String?) {
    let appDel = UIApplication.shared.delegate as? AppDelegate
    guard let context = appDel?.persistentContainer.viewContext else { return }
    do {
        if dataType == "Record" {
            let results = try context.fetch(PlayingPlayer.fetchRequest())
            // If CoreData already have data
            if results.count >= 9 {
                for (i,item) in results.enumerated() {
                    let editPlayer = item as? PlayingPlayer
                    if editPlayer?.name == players[i].name {
                        editPlayer?.mid = players[i].mid
                        editPlayer?.name = players[i].name
                        editPlayer?.position = players[i].position
                        editPlayer?.profileImage = players[i].profileImage
                        let array = players[i].recordArray
                        let data = NSKeyedArchiver.archivedData(withRootObject: array)
                        editPlayer?.recordArray = data as NSData
                        appDel?.saveContext()
                    }
                }
                
                // No Data
            } else {
                for savedPlayer in players {
                    let player = PlayingPlayer(context: context)
                    player.mid = savedPlayer.mid
                    player.name = savedPlayer.name
                    player.position = savedPlayer.position
                    player.order = savedPlayer.order
                    player.profileImage = savedPlayer.profileImage
                    let array = savedPlayer.recordArray
                    let data = NSKeyedArchiver.archivedData(withRootObject: array)
                    player.recordArray = data as NSData
                    appDel?.saveContext()
                }
            }
        } else if dataType == "Opponent" {
            let results = try context.fetch(OpponentPlayer.fetchRequest())
            // If CoreData already have data
            if results.count >= 9 {
                for (i,item) in results.enumerated() {
                    let editPlayer = item as? OpponentPlayer
                    if editPlayer?.name == players[i].name {
                        editPlayer?.mid = players[i].mid
                        editPlayer?.name = players[i].name
                        editPlayer?.position = players[i].position
                        editPlayer?.profileImage = players[i].profileImage
                        let array = players[i].recordArray
                        let data = NSKeyedArchiver.archivedData(withRootObject: array)
                        editPlayer?.recordArray = data as NSData
                        appDel?.saveContext()
                    }
                }
                
                // No Data
            } else {
                for savedPlayer in players {
                    let player = OpponentPlayer(context: context)
                    player.mid = savedPlayer.mid
                    player.name = savedPlayer.name
                    player.position = savedPlayer.position
                    player.order = savedPlayer.order
                    player.profileImage = savedPlayer.profileImage
                    let array = savedPlayer.recordArray
                    let data = NSKeyedArchiver.archivedData(withRootObject: array)
                    player.recordArray = data as NSData
                    appDel?.saveContext()
                }
            }
        }
        
    } catch {
        
    }
    
}

func fetchDataFromCoreData(dataType: String) -> [Player] {
    var players = [Player]()
    let appDel = UIApplication.shared.delegate as? AppDelegate
    guard let context = appDel?.persistentContainer.viewContext else { return [] }
    do {
        if dataType == "Record" {
            let result = try context.fetch(PlayingPlayer.fetchRequest())
            for item in result {
                let thisPlayer = item as? PlayingPlayer
                // Reconstruct by using map
                
                if thisPlayer?.recordArray != nil {
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: (thisPlayer?.recordArray as NSData?)! as Data)
                    let arrayObject = unarchiveObject as AnyObject! as! Array<String>
                    let array = arrayObject
                    players.append(Player(mid: thisPlayer?.mid, name: thisPlayer?.name, order: thisPlayer?.order, position: thisPlayer?.position, recordArray: array, profileImage: thisPlayer?.profileImage))
                } else {
                    players.append(Player(mid: thisPlayer?.mid, name: thisPlayer?.name, order: thisPlayer?.order, position: thisPlayer?.position, recordArray: [], profileImage: thisPlayer?.profileImage))
                }
            }
        } else if dataType == "Opponent" {
            let result = try context.fetch(OpponentPlayer.fetchRequest())
            for item in result {
                let thisPlayer = item as? OpponentPlayer
                // Reconstruct by using map
                
                if thisPlayer?.recordArray != nil {
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: (thisPlayer?.recordArray as NSData?)! as Data)
                    let arrayObject = unarchiveObject as AnyObject! as! Array<String>
                    let array = arrayObject
                    players.append(Player(mid: thisPlayer?.mid, name: thisPlayer?.name, order: thisPlayer?.order, position: thisPlayer?.position, recordArray: array, profileImage: thisPlayer?.profileImage))
                } else {
                    players.append(Player(mid: thisPlayer?.mid, name: thisPlayer?.name, order: thisPlayer?.order, position: thisPlayer?.position, recordArray: [], profileImage: thisPlayer?.profileImage))
                }
            }
        }
        
    } catch {
        
    }
    return players
}
