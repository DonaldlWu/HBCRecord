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
        guard let gamingStatus = UserDefaults.standard.string(forKey: "gaming") else {
            return
        }
        if gamingStatus == "false" {
            for i in 0...17 {
                self.opponent.append(Player(mid: "OPPONENT", name: "UNKNOW", order: "\(i)", position: "UNKNOW", recordArray: [], profileImage: nil))
            }
        }
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let recordController = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        recordController.players = self.players
        recordController.opponent = self.opponent
        let opponentController = OpponentController(collectionViewLayout: UICollectionViewFlowLayout())
        opponentController.players = self.players
        opponentController.opponent = self.opponent
        saveToCoreData(players: self.players, dataType: "Record")
        saveToCoreData(players: self.opponent, dataType: "Opponent")
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
