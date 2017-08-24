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
        image.image = #imageLiteral(resourceName: "HBC")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 32
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .cyan
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Yohoho"
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
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
        text.isEditable = false
        return text
    }()
    
    lazy var sentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 5
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    lazy var undoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 5
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
        
        orderLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        orderLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        orderLabel.leftAnchor.constraint(equalTo: profileImage.leftAnchor).isActive = true
        orderLabel.rightAnchor.constraint(equalTo: profileImage.rightAnchor).isActive = true
        
        sentButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sentButton.topAnchor.constraint(equalTo: orderLabel.bottomAnchor).isActive = true
        sentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sentButton.widthAnchor.constraint(equalToConstant: self.frame.size.width / 2).isActive = true
        
        undoButton.leftAnchor.constraint(equalTo: sentButton.rightAnchor).isActive = true
        undoButton.topAnchor.constraint(equalTo: sentButton.topAnchor).isActive = true
        undoButton.bottomAnchor.constraint(equalTo: sentButton.bottomAnchor).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: self.frame.size.width / 2).isActive = true
        
        recordText.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12).isActive = true
        recordText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        recordText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8).isActive = true
        recordText.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: recordText.leftAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 84).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
