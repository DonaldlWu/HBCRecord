//
//  GameStateController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/21.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class GameStateController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let newTeamButton = UIBarButtonItem(title: "GAME SET", style: .plain, target: self, action: #selector(backHome))
        self.navigationItem.rightBarButtonItem = newTeamButton
    }
    
    func backHome() {
        let controller = HomeController()
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    
}
