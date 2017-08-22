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
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.players.sort(by: { (first: Player , second: Player) -> Bool in
            Int(first.order!)! < Int(second.order!)!
        })
        
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
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
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: nil)
    }
    
    func uudoRecord(sender: UIButton) {
        if self.players[sender.tag].recordArray.count != 0 {
            self.players[sender.tag].recordArray.removeLast()
            let controller = GameTabBarController()
            controller.players = self.players
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

