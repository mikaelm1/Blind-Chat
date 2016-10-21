//
//  UsersCell.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/14/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework

class MessagesCell: UICollectionViewCell {
    
    let messageLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0 
        return l
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "profile_placeholder")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let seperator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = FlatBlue()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = FlatWhite()
        setupViews()
    }
    
    override func layoutSubviews() {
        layoutIfNeeded()
    }
    
    func configureCell(forMessage message: String) {
        messageLabel.text = message
        
    }
    
    func setupViews() {
        
        addSubview(seperator)
        seperator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        seperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        seperator.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(profileImage)
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        profileImage.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 8).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(messageLabel)
        messageLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        messageLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
