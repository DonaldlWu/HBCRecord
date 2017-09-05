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
    let footerId = "footerId"
    var players = [Player]()
    var opponent = [Player]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let topOrBottomStatus = UserDefaults.standard.string(forKey: "TopOrBottom"), let teamName = UserDefaults.standard.string(forKey: "TeamName") else {
            return
        }
        navigationItem.title = "\(topOrBottomStatus): \(teamName)"
        
        self.players.sort(by: { (first: Player , second: Player) -> Bool in
            Int(first.order!)! < Int(second.order!)!
        })
        let button = UIBarButtonItem(title: "CHANGE", style: .done, target: self, action: #selector(inningChangeAlert))
        navigationItem.rightBarButtonItem = button
        
        collectionView?.backgroundColor = .white
        collectionView?.register(RecordCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "RELOADING")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    func covertData(players: [Player]) -> Array<Int> {
        var array = [0, 0, 0]
        var run = 0
        var hit = 0
        var error = 0
        for record in players {
            
            guard let mid = record.mid else {
                return array
            }
            var recordValue = recordConversion(player: record)
            recordValue.updateValue(recordValue, forKey: mid)
            let R = recordValue["R"] as! Int
            run = run + R
            let H = recordValue["H"] as! Int
            hit = hit + H
            let E = recordValue["E"] as! Int
            error = error + E
            
        }
        array[0] = run
        array[1] = hit
        array[2] = error
        return array
    }
    
    func inningChangeAlert() {
        let alertController = UIAlertController(title: nil, message: "結束這半局", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .default, handler: {
            alert -> Void in
        })
        let descide = UIAlertAction(title: "確定", style: .destructive, handler: {
            alert -> Void in
            self.inningChange()
        })
        
        alertController.addAction(cancel)
        alertController.addAction(descide)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func inningChange() {
        guard let change = UserDefaults.standard.string(forKey: "Change") else {
            return
        }
        if change == "self" {
            let array = covertData(players: self.players)
            UserDefaults.standard.setValue("opponent", forKey: "Change")
            let controller = GameTabBarController()
            controller.dataArray = array
            controller.change = true
            controller.players = self.players
            controller.opponent = self.opponent
            controller.sendBy = "Opponent"
            inning = inning + 1
            UserDefaults.standard.setValue(inning, forKey: "inning")
            present(controller, animated: false, completion: nil)
        } else if change == "opponent" {
            let alertController = UIAlertController(title: nil, message: "請先結束另一方的半局", preferredStyle: .alert)
            let top = UIAlertAction(title: "知道了", style: .default, handler: {
                alert -> Void in
            })
            alertController.addAction(top)
            self.present(alertController, animated: true, completion: nil)
        }
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        } else {
            return players.count - 9
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let indexPath = indexPath
        if indexPath.section == 0 {
            return cellCreate(indexPath: indexPath, number: indexPath.item)
        } else {
            return cellCreate(indexPath: indexPath, number: indexPath.item + 9)
        }
        
    }
    
    func cellCreate(indexPath: IndexPath, number: Int) -> RecordCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? RecordCell
        let player = players[number]
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
        controller.opponent = self.opponent
        controller.sendby = "Record"
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: nil)
    }
    
    func uudoRecord(sender: UIButton) {
        if self.players[sender.tag].recordArray.count != 0 {
            self.players[sender.tag].recordArray.removeLast()
            let controller = GameTabBarController()
            controller.players = self.players
            controller.opponent = self.opponent
            controller.sendBy = "Record"
            present(controller, animated: false, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 125)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        footer.backgroundColor = .cyan
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 12)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

}

