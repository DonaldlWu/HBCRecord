//
//  RecordCell.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/6/26.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class RecordCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "pied piper")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        return image
    }()
    
    let orderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = "四棒/投手"
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Yohoho"
        label.layer.borderColor = UIColor.cyan.cgColor
        label.layer.borderWidth = 3
        return label
    }()
    
    let recordText: UITextView = {
        let text = UITextView()
        text.textAlignment = .left
        text.text = "一安 / 三振 / 保送 / 二安"
        text.font = UIFont.boldSystemFont(ofSize: 14)
        text.layer.borderColor = UIColor.cyan.cgColor
        text.layer.borderWidth = 3
        text.isScrollEnabled = false
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var sentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    lazy var undoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.setTitle("UNDO", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    func setupView() {
        addSubview(profileImage)
        addSubview(recordText)
        addSubview(sentButton)
        addSubview(undoButton)
        addSubview(orderLabel)
        addSubview(nameLabel)
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 64).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        sentButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -18).isActive = true
        sentButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        sentButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sentButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        undoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 18).isActive = true
        undoButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        recordText.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12).isActive = true
        recordText.rightAnchor.constraint(equalTo: sentButton.leftAnchor, constant: -12).isActive = true
        recordText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12).isActive = true
        recordText.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        orderLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        orderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        orderLabel.leftAnchor.constraint(equalTo: profileImage.leftAnchor).isActive = true
        orderLabel.rightAnchor.constraint(equalTo: profileImage.rightAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: recordText.leftAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: recordText.topAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 84).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
