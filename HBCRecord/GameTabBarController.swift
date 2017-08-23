//
//  GameTabBarController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/21.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import CoreData

class GameTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var players = [Player]()
    var opponent = [Player]()
    var sendBy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if opponent.count == 0 {
            for i in 0...17 {
                self.opponent.append(Player(mid: "OPPONENT", name: "UNKNOW", order: "\(i)", position: "UNKNOW", recordArray: [], profileImage: nil))
            }
        }
        delegate = self
    }
    
    func saveToCoreData() {
        let appDel = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDel?.persistentContainer.viewContext else { return }
        do {
            let results = try context.fetch(PlayingPlayer.fetchRequest())
            
            // If CoreData already have data
            if results.count >= 9 {
                for (i,item) in results.enumerated() {
                    let editPlayer = item as? PlayingPlayer
                    if editPlayer?.name == self.players[i].name {
                        editPlayer?.mid = self.players[i].mid
                        editPlayer?.name = self.players[i].name
                        editPlayer?.position = self.players[i].position
                        editPlayer?.profileImage = self.players[i].profileImage
                        let array = self.players[i].recordArray
                        let data = NSKeyedArchiver.archivedData(withRootObject: array)
                        editPlayer?.recordArray = data as NSData
                        appDel?.saveContext()
                    }
                }
                
            // No Data
            } else {
                for savedPlayer in self.players {
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
        } catch {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let recordController = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        recordController.players = self.players
        recordController.opponent = self.opponent
        let opponentController = OpponentController(collectionViewLayout: UICollectionViewFlowLayout())
        opponentController.players = self.players
        opponentController.opponent = self.opponent
        saveToCoreData()
        // Set game staus
        UserDefaults.standard.setValue("true", forKey: "gaming")
        let itemOne = UINavigationController(rootViewController: recordController)
        let itemTwo = UINavigationController(rootViewController: opponentController)
        let itemThree = UINavigationController(rootViewController: GameStateController())
        let icon1 = UITabBarItem(tabBarSystemItem:  UITabBarSystemItem.bookmarks, tag: 0)
        let icon2 = UITabBarItem(tabBarSystemItem:  UITabBarSystemItem.favorites, tag: 0)
        let icon3 = UITabBarItem(tabBarSystemItem:  UITabBarSystemItem.downloads, tag: 0)
        itemOne.tabBarItem = icon1
        itemTwo.tabBarItem = icon2
        itemThree.tabBarItem = icon3
        
        let controllers = [itemOne, itemTwo, itemThree]
        self.viewControllers = controllers
        
        if sendBy == "Opponent" {
            self.selectedViewController = controllers[1]
        } else {
            self.selectedViewController = controllers[0]
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(String(describing: viewController.title)) ?")
        return true
    }
}
