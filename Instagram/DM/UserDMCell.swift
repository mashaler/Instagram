//
//  UserDMCell.swift
//  Instagram
//
//  Created by Rolva Mashale on 2024/09/06.
//

import Foundation
import UIKit

protocol UserDMCellDelegate: AnyObject {
    func userDidFetch(for user: User, with cell: UserDMCell)
}

class UserDMCell: UITableViewCell {
    
    weak var delegate: UserDMCellDelegate?
    
    var user: User? {
        didSet {
            self.usernameLabel.text = user?.username
            self.profileImageView.loadImage(urlString: user!.profileImageUrl)
            //setupPreviewMessage()
            delegate?.userDidFetch(for: user!, with: self)
        }
    }
    
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    //
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        //label.backgroundColor = .red
        return label
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        //label.backgroundColor = .secondarySystemBackground
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        //label.font = UIFont.boldSystemFont(ofSize: 13)
        //label.backgroundColor = .secondarySystemBackground
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       sharedInit()
    }
    
    private func sharedInit() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(lastMessageLabel)
        addSubview(timeLabel)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50 / 2
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
        lastMessageLabel.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 8, width: 0, height: 20)
        
        timeLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
    }
    
}
