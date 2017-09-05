//
//  MemberCell.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/17.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "HBC")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 35
        image.layer.masksToBounds = true
        return image
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
//    let AVGLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .left
//        return label
//    }()
//    
//    let OBPLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .left
//        return label
//    }()
//    
//    let SLGLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .left
//        return label
//    }()
//    
//    let OPSLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .left
//        return label
//    }()
    
    lazy var lineupSelectButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = ""
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.cyan.cgColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var lineupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .green
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(numberLabel)
        addSubview(nameLabel)
//        addSubview(AVGLabel)
//        addSubview(OBPLabel)
//        addSubview(SLGLabel)
//        addSubview(OPSLabel)
        addSubview(lineupSelectButton)
        addSubview(lineupLabel)
        lineupLabel.isHidden = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        numberLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        numberLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 72).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
//        AVGLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
//        AVGLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
//        AVGLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
//        AVGLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        
//        OBPLabel.topAnchor.constraint(equalTo: AVGLabel.bottomAnchor).isActive = true
//        OBPLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
//        OBPLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
//        OBPLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        
//        SLGLabel.topAnchor.constraint(equalTo: OBPLabel.bottomAnchor).isActive = true
//        SLGLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
//        SLGLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
//        SLGLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        
//        OPSLabel.topAnchor.constraint(equalTo: SLGLabel.bottomAnchor).isActive = true
//        OPSLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
//        OPSLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
//        OPSLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    
        lineupSelectButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        lineupSelectButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lineupSelectButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        lineupSelectButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        lineupLabel.rightAnchor.constraint(equalTo: lineupSelectButton.leftAnchor, constant: -12).isActive = true
        lineupLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lineupLabel.widthAnchor.constraint(equalToConstant: 48).isActive = true
        lineupLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
