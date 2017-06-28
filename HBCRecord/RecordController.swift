//
//  ViewController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/6/25.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

var recordArray0 = ["一安", "三振", "保送", "二安"]
var recordArray1 = ["一安", "三振", "保送", "二安"]
var recordArray2 = ["一安", "三振", "保送", "二安"]
var recordArray3 = ["一安", "三振", "保送", "二安"]
var recordArray4 = ["一安", "三振", "保送", "二安"]
var recordArray5 = ["一安", "三振", "保送", "二安"]
var recordArray6 = ["一安", "三振", "保送", "二安"]
var recordArray7 = ["一安", "三振", "保送", "二安"]
var recordArray8 = ["一安", "三振", "保送", "二安"]


class RecordController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "CellId"
    
    let players: [Player] = {
        let player1 = Player(name: "Yohoho", order: "一棒", position: "中外", recordArray: recordArray0, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player2 = Player(name: "Yohoho", order: "二棒", position: "二壘", recordArray: recordArray1, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player3 = Player(name: "Yohoho", order: "三棒", position: "游擊", recordArray: recordArray2, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player4 = Player(name: "Yohoho", order: "四棒", position: "一壘", recordArray: recordArray3, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player5 = Player(name: "Yohoho", order: "五棒", position: "三壘", recordArray: recordArray4, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player6 = Player(name: "Yohoho", order: "六棒", position: "捕手", recordArray: recordArray5, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player7 = Player(name: "Yohoho", order: "七棒", position: "DH", recordArray: recordArray6, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player8 = Player(name: "Yohoho", order: "八棒", position: "右外", recordArray: recordArray7, profileImage: #imageLiteral(resourceName: "pied piper"))
        let player9 = Player(name: "Yohoho", order: "九棒", position: "左外", recordArray: recordArray8, profileImage: #imageLiteral(resourceName: "pied piper"))
        return [player1, player2, player3, player4, player5, player6, player7, player8, player9]
    }()
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .green
        collectionView?.register(RecordCell.self, forCellWithReuseIdentifier: cellId)
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
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
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? RecordCell
        cell?.backgroundColor = .blue
        cell?.sentButton.tag = indexPath.item
        let player = players[indexPath.item]
        cell?.sentButton.addTarget(self, action: #selector(sentRecord(sender:)), for: .touchUpInside)
        cell?.profileImage.image = player.profileImage
        cell?.orderLabel.text = player.order + " - " + player.position
        cell?.recordText.text = String(describing: player.recordArray)
        return cell!
    }
    
    func sentRecord(sender: UIButton) {
        
        print("Hit Button\(sender.tag)")
        switch sender.tag {
        case 0:
            recordArray0.append("New Record1")
        case 1:
            recordArray1.append("New Record1")
        case 2:
            recordArray2.append("New Record2")
        case 3:
            recordArray3.append("New Record3")
        case 4:
            recordArray4.append("New Record4")
        case 5:
            recordArray5.append("New Record5")
        case 6:
            recordArray6.append("New Record6")
        case 7:
            recordArray7.append("New Record7")
        case 8:
            recordArray8.append("New Record8")
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

}

