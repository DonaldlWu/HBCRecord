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

    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        let backButton = UIBarButtonItem(title: "BACK",
                                            style: .done, target: self, action: #selector(RecordController.backAction))
        navigationItem.leftBarButtonItem = backButton
        
        collectionView?.backgroundColor = .white
        collectionView?.register(RecordCell.self, forCellWithReuseIdentifier: cellId)
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    func didRotation() {
        collectionView?.reloadData()
    }
    
    func backAction() -> Void {
        let controller = HomeController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
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
        let player = players[indexPath.item]
        cell?.sentButton.tag = indexPath.item
        cell?.undoButton.tag = indexPath.item
        cell?.sentButton.addTarget(self, action: #selector(sentRecord(sender:)), for: .touchUpInside)
        cell?.undoButton.addTarget(self, action: #selector(uudoRecord(sender:)), for: .touchUpInside)
        if let playerProfileImage = player.profileImage {
            cell?.profileImage.loadImageUsingCashWithUrlString(urlString: playerProfileImage)
        }
        cell?.nameLabel.text = player.name
        cell?.orderLabel.text = orderArray[Int(player.order!)!] + " - " + player.position!
//        let recordString = player.recordArray.flatMap { $0.characters }
//        cell?.recordText.text = String(recordString)
        cell?.recordText.text = String(describing: player.recordArray)
        return cell!
    }
    
    func sentRecord(sender: UIButton) {
        let controller = RecordPickerController()
        controller.rowInRecordArray = sender.tag
        present(controller, animated: true, completion: nil)
    }
    
    func uudoRecord(sender: UIButton) {
        switch sender.tag {
        case 0:
            if recordArray0.count > 0 {
                players[0].recordArray.remove(at: recordArray0.count - 1)
                recordArray0.remove(at: recordArray0.count - 1)
            }
        case 1:
            if recordArray1.count > 0 {
                players[1].recordArray.remove(at: recordArray1.count - 1)
                recordArray1.remove(at: recordArray1.count - 1)
            }
        case 2:
            if recordArray2.count > 0 {
                players[2].recordArray.remove(at: recordArray2.count - 1)
                recordArray2.remove(at: recordArray2.count - 1)
            }
        case 3:
            if recordArray3.count > 0 {
                players[3].recordArray.remove(at: recordArray3.count - 1)
                recordArray3.remove(at: recordArray3.count - 1)
            }
        case 4:
            if recordArray4.count > 0 {
                players[4].recordArray.remove(at: recordArray4.count - 1)
                recordArray4.remove(at: recordArray4.count - 1)
            }
        case 5:
            if recordArray5.count > 0 {
                players[5].recordArray.remove(at: recordArray5.count - 1)
                recordArray5.remove(at: recordArray5.count - 1)
            }
        case 6:
            if recordArray6.count > 0 {
                players[6].recordArray.remove(at: recordArray6.count - 1)
                recordArray6.remove(at: recordArray6.count - 1)
            }
        case 7:
            if recordArray7.count > 0 {
                players[7].recordArray.remove(at: recordArray7.count - 1)
                recordArray7.remove(at: recordArray7.count - 1)
            }
        case 8:
            if recordArray8.count > 0 {
                players[8].recordArray.remove(at: recordArray8.count - 1)
                recordArray8.remove(at: recordArray8.count - 1)
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

