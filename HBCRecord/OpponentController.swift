//
//  OpponentController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/8/23.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class OpponentController: RecordController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func sentRecord(sender: UIButton) {
        let controller = RecordPickerController()
        controller.rowInRecordArray = sender.tag
        controller.players = self.players
        controller.opponent = self.opponent
        controller.sendby = "Opponent"
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: nil)
    }
    
    override func uudoRecord(sender: UIButton) {
        if self.players[sender.tag].recordArray.count != 0 {
            self.players[sender.tag].recordArray.removeLast()
            let controller = GameTabBarController()
            controller.players = self.players
            controller.opponent = self.opponent
            controller.sendBy = "Opponent"
            present(controller, animated: false, completion: nil)
        }
    }
    
    override func inningChange() {
        guard let change = UserDefaults.standard.string(forKey: "Change") else {
            return
        }
        if change == "self" {
            let alertController = UIAlertController(title: nil, message: "請先結束另一方的半局", preferredStyle: .alert)
            let top = UIAlertAction(title: "知道了", style: .default, handler: {
                alert -> Void in
            })
            alertController.addAction(top)
            self.present(alertController, animated: true, completion: nil)
        } else if change == "opponent" {
            let array = covertData(players: self.opponent)
            UserDefaults.standard.setValue("self", forKey: "Change")
            let controller = GameTabBarController()
            controller.dataArray = array
            controller.change = true
            controller.players = self.players
            controller.opponent = self.opponent
            controller.sendBy = "Record"
            inning = inning + 1
            UserDefaults.standard.setValue(inning, forKey: "inning")
            present(controller, animated: false, completion: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        } else {
            return opponent.count - 9
        }
    }
    
    override func cellCreate(indexPath: IndexPath, number: Int) -> RecordCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? RecordCell
        let player = opponent[number]
        cell?.sentButton.tag = indexPath.item
        cell?.undoButton.tag = indexPath.item
        cell?.sentButton.addTarget(self, action: #selector(sentRecord(sender:)), for: .touchUpInside)
        cell?.undoButton.addTarget(self, action: #selector(uudoRecord(sender:)), for: .touchUpInside)
        if let playerProfileImage = player.profileImage {
            cell?.profileImage.loadImageUsingCashWithUrlString(urlString: playerProfileImage)
        }
        cell?.nameLabel.text = player.name
        if Int((player.order!))! <= 8 {
            cell?.orderLabel.text = orderArray[Int((player.order!))!] + " - " + (player.position!)
        } else {
            cell?.orderLabel.text = "BN" + " - " + (player.position!)
        }
        
        let str = player.recordArray.flatMap {($0)! + "  " }.joined()
        cell?.recordText.text = str
        return cell!
    }
    
}
