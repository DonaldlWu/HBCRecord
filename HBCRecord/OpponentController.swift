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
            cell?.orderLabel.text = "BN"
        }
        
        let str = player.recordArray.flatMap {($0)! + "  " }.joined()
        cell?.recordText.text = str
        return cell!
    }
    
}
