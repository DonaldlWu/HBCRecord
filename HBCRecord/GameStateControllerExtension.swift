//
//  GameStateControllerExtension.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/8/24.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import CoreData

extension GameStateController {

    func setupConstrain() {
        
        view.backgroundColor = .white
        
        view.addSubview(containView)
        
        containView.addSubview(separateViewVerOne)
        containView.addSubview(myCollectionView)
        containView.addSubview(separateViewVerTwo)
        containView.addSubview(separateViewHorOne)
        containView.addSubview(separateViewHorTwo)
        containView.addSubview(separateViewVerThree)
        containView.addSubview(separateViewVerFour)
        containView.addSubview(inningLabel)
        containView.addSubview(topTeamLabel)
        containView.addSubview(bottomNameLabel)
        containView.addSubview(runLabel)
        containView.addSubview(topRunLabel)
        containView.addSubview(bottomRunLabel)
        containView.addSubview(hitLabel)
        containView.addSubview(errorLabel)
        
        if topOrBottomStatus == "先攻" {
            topTeamLabel.text = teamName
        } else if topOrBottomStatus == "先守" {
            bottomNameLabel.text = teamName
        }
        
        containView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        containView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 7).isActive = true
        
        separateViewHorOne.topAnchor.constraint(equalTo: containView.topAnchor, constant: (view.frame.size.height / 7) / 3).isActive = true
        separateViewHorOne.rightAnchor.constraint(equalTo: containView.rightAnchor).isActive = true
        separateViewHorOne.leftAnchor.constraint(equalTo: containView.leftAnchor).isActive = true
        separateViewHorOne.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        separateViewVerOne.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        separateViewVerOne.centerXAnchor.constraint(equalTo: containView.leftAnchor, constant: (view.frame.size.width) / 4.5).isActive = true
        separateViewVerOne.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        separateViewVerOne.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        let width = (view.frame.size.width) / 3.5
        
        separateViewVerTwo.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        separateViewVerTwo.centerXAnchor.constraint(equalTo: containView.leftAnchor, constant: 2.75 * width).isActive = true
        separateViewVerTwo.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        separateViewVerTwo.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        separateViewVerThree.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        separateViewVerThree.centerXAnchor.constraint(equalTo: containView.leftAnchor, constant: 3 * width).isActive = true
        separateViewVerThree.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        separateViewVerThree.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        separateViewVerFour.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        separateViewVerFour.centerXAnchor.constraint(equalTo: containView.leftAnchor, constant: 3.25 * width).isActive = true
        separateViewVerFour.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        separateViewVerFour.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        separateViewHorTwo.topAnchor.constraint(equalTo: containView.topAnchor, constant: (view.frame.size.height / 7) * 2 / 3).isActive = true
        separateViewHorTwo.rightAnchor.constraint(equalTo: containView.rightAnchor).isActive = true
        separateViewHorTwo.leftAnchor.constraint(equalTo: containView.leftAnchor).isActive = true
        separateViewHorTwo.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        myCollectionView.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: separateViewVerTwo.leftAnchor).isActive = true
        myCollectionView.leftAnchor.constraint(equalTo: separateViewVerOne.rightAnchor).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        
        inningLabel.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        inningLabel.rightAnchor.constraint(equalTo: separateViewVerOne.leftAnchor).isActive = true
        inningLabel.leftAnchor.constraint(equalTo: containView.leftAnchor).isActive = true
        inningLabel.bottomAnchor.constraint(equalTo: separateViewHorOne.topAnchor).isActive = true
        
        topTeamLabel.topAnchor.constraint(equalTo: separateViewHorOne.bottomAnchor).isActive = true
        topTeamLabel.rightAnchor.constraint(equalTo: separateViewVerOne.leftAnchor).isActive = true
        topTeamLabel.leftAnchor.constraint(equalTo: containView.leftAnchor).isActive = true
        topTeamLabel.bottomAnchor.constraint(equalTo: separateViewHorTwo.topAnchor).isActive = true
        
        bottomNameLabel.topAnchor.constraint(equalTo: separateViewHorTwo.bottomAnchor).isActive = true
        bottomNameLabel.rightAnchor.constraint(equalTo: separateViewVerOne.leftAnchor).isActive = true
        bottomNameLabel.leftAnchor.constraint(equalTo: containView.leftAnchor).isActive = true
        bottomNameLabel.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        
        runLabel.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        runLabel.rightAnchor.constraint(equalTo: separateViewVerThree.leftAnchor).isActive = true
        runLabel.leftAnchor.constraint(equalTo: separateViewVerTwo.rightAnchor).isActive = true
        runLabel.bottomAnchor.constraint(equalTo: separateViewHorOne.topAnchor).isActive = true
        
        topRunLabel.topAnchor.constraint(equalTo: separateViewHorOne.bottomAnchor).isActive = true
        topRunLabel.rightAnchor.constraint(equalTo: separateViewVerThree.leftAnchor).isActive = true
        topRunLabel.leftAnchor.constraint(equalTo: separateViewVerTwo.rightAnchor).isActive = true
        topRunLabel.bottomAnchor.constraint(equalTo: separateViewHorTwo.topAnchor).isActive = true
        
        bottomRunLabel.topAnchor.constraint(equalTo: separateViewHorTwo.bottomAnchor).isActive = true
        bottomRunLabel.rightAnchor.constraint(equalTo: separateViewVerThree.leftAnchor).isActive = true
        bottomRunLabel.leftAnchor.constraint(equalTo: separateViewVerTwo.rightAnchor).isActive = true
        bottomRunLabel.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        
        hitLabel.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        hitLabel.rightAnchor.constraint(equalTo: separateViewVerFour.leftAnchor).isActive = true
        hitLabel.leftAnchor.constraint(equalTo: separateViewVerThree.rightAnchor).isActive = true
        hitLabel.bottomAnchor.constraint(equalTo: separateViewHorOne.topAnchor).isActive = true
        
        errorLabel.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: containView.rightAnchor).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: separateViewVerFour.rightAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: separateViewHorOne.topAnchor).isActive = true
    }

    
}
