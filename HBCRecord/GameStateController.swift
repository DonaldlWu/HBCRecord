//
//  GameStateController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/21.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import CoreData

class GameStateController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let newTeamButton = UIBarButtonItem(title: "GAME SET", style: .plain, target: self, action: #selector(backHome))
        self.navigationItem.rightBarButtonItem = newTeamButton
    }
    
    func backHome() {
        // Delete all data from coreData
        deleteAllRecords()
        UserDefaults.standard.setValue("false", forKey: "gaming")
        let controller = HomeController()
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayingPlayer")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
}
