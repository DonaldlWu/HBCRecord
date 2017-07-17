//
//  TeamCell.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/17.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 35
        image.layer.masksToBounds = true
        return image
    }()
    
    let teamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(teamLabel)
        
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        teamLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        teamLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        teamLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        teamLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
