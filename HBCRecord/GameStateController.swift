//
//  GameStateController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/21.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import CoreData

class GameStateController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var teamName: String?
    var topOrBottomStatus: String?
    var dataArray: Array<Int>?
    
    lazy var myCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ScoreCell.self, forCellWithReuseIdentifier: "CellId")
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .yellow
        return cv
    }()
    
    let inningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "局數"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let topTeamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "AWAY"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let bottomNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "HOME"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let runLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "R"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let topRunLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let bottomRunLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let hitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "H"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let topHitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let bottomHitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "E"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let topErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let bottomErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let separateViewHorOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let separateViewHorTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let separateViewVerOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let separateViewVerTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let separateViewVerThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let separateViewVerFour: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let containView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 3
        view.layer.backgroundColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrain()
        let newTeamButton = UIBarButtonItem(title: "GAME SET", style: .plain, target: self, action: #selector(backHome))
        self.navigationItem.rightBarButtonItem = newTeamButton
//        changeGameStatusLabel()
    }
    
    func changeGameStatusLabel() {
        inning = UserDefaults.standard.integer(forKey: "inning")
        let topOrBottom = inning - 1
        if let run = dataArray?[0], let hit = dataArray?[1], let error = dataArray?[2] {
            let runString = String(run)
            let hitString = String(hit)
            let errorString = String(error)
            if topOrBottom % 2 == 0 {
                topStatus[0] = runString
                topStatus[1] = hitString
                topStatus[2] = errorString
            } else {
                bottomStatus[0] = runString
                bottomStatus[1] = hitString
                bottomStatus[2] = errorString
            }
            let topStatusDefault = UserDefaults.standard
            topStatusDefault.set(topStatus, forKey: "topStatus")
            topStatusDefault.synchronize()
            let bottomStatusDefault = UserDefaults.standard
            bottomStatusDefault.set(bottomStatus, forKey: "bottomStatus")
            bottomStatusDefault.synchronize()
        }
        
        topRunLabel.text = topStatus[0]
        topHitLabel.text = topStatus[1]
        topErrorLabel.text = bottomStatus[2]
        bottomRunLabel.text = bottomStatus[0]
        bottomHitLabel.text = bottomStatus[1]
        bottomErrorLabel.text = topStatus[2]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topScoreArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? ScoreCell
        cell?.inningLabel.text = "\(indexPath.item + 1)"
        cell?.topScoreLabel.text = topScoreArray[indexPath.item]
        cell?.bottomScoreLabel.text = bottomScoreArray[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: containView.frame.size.width / 16, height: containView.frame.size.height)
    }

    
    func backHome() {
        // Delete all data from coreData
        deleteAllRecords()
        inning = 0
        topScoreArray = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        bottomScoreArray = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        topStatus = ["0", "0", "0"]
        bottomStatus = ["0", "0", "0"]
        
        UserDefaults.standard.setValue(inning, forKey: "inning")
        UserDefaults.standard.setValue("false", forKey: "gaming")
        let topStatusDefault = UserDefaults.standard
        topStatusDefault.set(topStatus, forKey: "topStatus")
        topStatusDefault.synchronize()
        let bottomStatusDefault = UserDefaults.standard
        bottomStatusDefault.set(bottomStatus, forKey: "bottomStatus")
        bottomStatusDefault.synchronize()
        let topScoreArrayUserDefault = UserDefaults.standard
        topScoreArrayUserDefault.set(topScoreArray, forKey: "topScoreArray")
        topScoreArrayUserDefault.synchronize()    
        let bottomScoreArrayUserDefault = UserDefaults.standard
        bottomScoreArrayUserDefault.set(bottomScoreArray, forKey: "bottomScoreArray")
        bottomScoreArrayUserDefault.synchronize()
    
    
    
        let controller = HomeController()
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayingPlayer")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let deleteOppFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "OpponentPlayer")
        let deleteOppRequest = NSBatchDeleteRequest(fetchRequest: deleteOppFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.execute(deleteOppRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
}
