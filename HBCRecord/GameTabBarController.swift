//
//  GameTabBarController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/21.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class GameTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var players = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let recordController = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        recordController.players = self.players
        let itemOne = UINavigationController(rootViewController: recordController)
        let itemTwo = UINavigationController(rootViewController: GameStateController())
        let item1 = itemOne
        let item2 = itemTwo
        let icon1 = UITabBarItem(tabBarSystemItem:  UITabBarSystemItem.bookmarks, tag: 0)
        let icon2 = UITabBarItem(tabBarSystemItem:  UITabBarSystemItem.favorites, tag: 0)
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        
        let controllers = [item1, item2]
        self.viewControllers = controllers
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(String(describing: viewController.title)) ?")
        return true
    }
}
