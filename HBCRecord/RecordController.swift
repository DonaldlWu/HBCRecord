//
//  ViewController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/6/25.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class RecordController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "CellId"
    var players = [Player]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.players.sort(by: { (first: Player , second: Player) -> Bool in
            Int(first.order!)! < Int(second.order!)!
        })
        
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        navigationItem.rightBarButtonItem = button
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        collectionView?.backgroundColor = .white
        collectionView?.register(RecordCell.self, forCellWithReuseIdentifier: cellId)
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    func saveData() {
        var recordDict: Dictionary<String, Any> = [:]
        for record in players {
            print("--------------------------------------------------")
            guard let mid = record.mid else {
                return
            }
            let recordValue = recordConversion(player: record)
            recordDict.updateValue(recordValue, forKey: mid)
            print("--------------------------------------------------")
        }
        print(recordDict)
        
    }
    
    func didRotation() {
        collectionView?.reloadData()
    }
    
    func refresh(sender:AnyObject)
    {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        self.refreshControl.endRefreshing()
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? RecordCell
        let player = players[indexPath.item]
        cell?.sentButton.tag = indexPath.item
        cell?.undoButton.tag = indexPath.item
        cell?.sentButton.addTarget(self, action: #selector(sentRecord(sender:)), for: .touchUpInside)
        cell?.undoButton.addTarget(self, action: #selector(uudoRecord(sender:)), for: .touchUpInside)
        if let playerProfileImage = player.profileImage {
            cell?.profileImage.loadImageUsingCashWithUrlString(urlString: playerProfileImage)
        }
        cell?.nameLabel.text = player.name
        cell?.orderLabel.text = orderArray[Int((player.order!))!] + " - " + (player.position!)
        let str = player.recordArray.flatMap {($0)! + "  " }.joined()
        cell?.recordText.text = str
        return cell!
    }
    
    func sentRecord(sender: UIButton) {
        let controller = RecordPickerController()
        controller.rowInRecordArray = sender.tag
        controller.players = self.players
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: nil)
    }
    
    func uudoRecord(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if self.players[0].recordArray.count != 0 {
                self.players[0].recordArray.removeLast()
            }
        case 1:
            if self.players[1].recordArray.count != 0 {
                self.players[1].recordArray.removeLast()
            }
        case 2:
            if self.players[2].recordArray.count != 0 {
                self.players[2].recordArray.removeLast()
            }
        case 3:
            if self.players[3].recordArray.count != 0 {
                self.players[3].recordArray.removeLast()
            }
        case 4:
            if self.players[4].recordArray.count != 0 {
                self.players[4].recordArray.removeLast()
            }
        case 5:
            if self.players[5].recordArray.count != 0 {
                self.players[5].recordArray.removeLast()
            }
        case 6:
            if self.players[6].recordArray.count != 0 {
                self.players[6].recordArray.removeLast()
            }
        case 7:
            if self.players[7].recordArray.count != 0 {
                self.players[7].recordArray.removeLast()
            }
        case 8:
            if self.players[8].recordArray.count != 0 {
                self.players[8].recordArray.removeLast()
            }
        default:
            return
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 80)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

}

