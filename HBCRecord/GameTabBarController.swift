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
    var dataArray: Array<Int>?
    var topScoreArray: Array<String>?
    var bottomScoreArray: Array<String>?
    var change: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inning = UserDefaults.standard.integer(forKey: "inning")
        guard let gamingStatus = UserDefaults.standard.string(forKey: "gaming") else {
            return
        }
        
        self.topScoreArray = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        self.bottomScoreArray = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        
        if gamingStatus == "false" {
            for i in 0...17 {
                self.opponent.append(Player(mid: "OPPONENT", name: "UNKNOW", order: "\(i)", position: "UNKNOW", recordArray: [], profileImage: nil))
            }
        }
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        returnScoreState()
        
        guard let topOrBottomStatus = UserDefaults.standard.string(forKey: "TopOrBottom"), let teamName = UserDefaults.standard.string(forKey: "TeamName")  else {
            return
        }
        
        let recordController = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        recordController.players = self.players
        recordController.opponent = self.opponent
        
        let opponentController = OpponentController(collectionViewLayout: UICollectionViewFlowLayout())
        opponentController.players = self.players
        opponentController.opponent = self.opponent
        
        let gameStateController = GameStateController()
        gameStateController.topScoreArray = self.topScoreArray
        gameStateController.bottomScoreArray = self.bottomScoreArray
        gameStateController.topOrBottomStatus = topOrBottomStatus
        gameStateController.teamName = teamName
        
        saveToCoreData(players: self.players, dataType: "Record")
        saveToCoreData(players: self.opponent, dataType: "Opponent")
        
        // Set game staus
        UserDefaults.standard.setValue("true", forKey: "gaming")
        
        let itemOne = UINavigationController(rootViewController: recordController)
        let itemTwo = UINavigationController(rootViewController: opponentController)
        let itemThree = UINavigationController(rootViewController: gameStateController)
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
    
    func returnScoreState() {
        if self.change == true {
            let inn = (inning - 1) / 2
            let topOrBottom = inning - 1
            if let score = dataArray?[0] {
               let string = String(score)
                if topOrBottom % 2 == 0 {
                    self.topScoreArray?[inn] = string
                } else if topOrBottom % 2 == 1 {
                    self.bottomScoreArray?[inn] = string
                }
            }
            
            self.change = false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
