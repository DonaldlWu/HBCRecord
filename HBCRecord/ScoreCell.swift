//
//  ScoreCell.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/8/23.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class ScoreCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inningLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.textColor = .black
        return label
    }()
    
    let topScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " "
        label.textColor = .black
        return label
    }()
    
    let bottomScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " "
        label.textColor = .black
        return label
    }()
    
    func setupView() {
        addSubview(inningLabel)
        addSubview(topScoreLabel)
        addSubview(bottomScoreLabel)
        addSubview(separateView)
        
        separateView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separateView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separateView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separateView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        inningLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        inningLabel.heightAnchor.constraint(equalToConstant: self.frame.size.height / 3).isActive = true
        inningLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        inningLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        topScoreLabel.topAnchor.constraint(equalTo: inningLabel.bottomAnchor).isActive = true
        topScoreLabel.heightAnchor.constraint(equalToConstant: self.frame.size.height / 3).isActive = true
        topScoreLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topScoreLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        bottomScoreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomScoreLabel.heightAnchor.constraint(equalToConstant: self.frame.size.height / 3).isActive = true
        bottomScoreLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomScoreLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
