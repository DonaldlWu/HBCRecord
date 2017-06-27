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
        label.backgroundColor = .orange
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "四棒/投手"
        return label
    }()
    
    let recordText: UITextView = {
        let text = UITextView()
        text.textAlignment = .left
        text.text = "一安 / 三振 / 保送 / 二安"
        text.font = UIFont.boldSystemFont(ofSize: 14)
        text.backgroundColor = .yellow
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
        button.addTarget(self, action: #selector(sentRecord), for: .touchUpInside)
        return button
    }()
    
    func setupView() {
        backgroundColor = .yellow
        addSubview(profileImage)
        addSubview(recordText)
        addSubview(sentButton)
        addSubview(orderLabel)
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        sentButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sentButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        sentButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sentButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        recordText.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12).isActive = true
        recordText.rightAnchor.constraint(equalTo: sentButton.leftAnchor, constant: -12).isActive = true
        recordText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        recordText.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        orderLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        orderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        orderLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        orderLabel.rightAnchor.constraint(equalTo: recordText.leftAnchor).isActive = true
    }
    
    func sentRecord() {
        print("Hit Button")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
