//
//  FriendsViewController.swift
//  MyMessenger
//
//  Created by Manikanta Nandam on 15/10/18.
//  Copyright © 2018 Manikanta. All rights reserved.
//

import UIKit


class FriendViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "FB Messenger"
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        setupData()
        
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count{
            return count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        cell.message = messages?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 100)
    }
    
    
    
    
    
    
    
}


class MessageCell: BaseCell {
    
    var message: Message? {
        didSet{
            nameLabel.text = message?.friend?.name
            profileImageView.image = UIImage(named: message!.friend!.profileImageName!)
            hasReadImage.image = UIImage(named: message!.friend!.profileImageName!)
            messageLabel.text = message!.text
            
            if let date = message?.date{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(from: date)
                
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true //can be replaced with bottom line
        //        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let deviderLineView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        return view
        
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My Friend"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friends message and something else..."
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "12:00 PM"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        
        return label
        
    }()
    
    let hasReadImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
        
    }()
    
    override func setupView() {
        //backgroundColor = UIColor.yellow
        
        addSubview(deviderLineView)
        
        addSubview(profileImageView)
        setupContainerView()
        profileImageView.image = UIImage(named: "myImage")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        deviderLineView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addConstraintWithFormat(format: "H:|-12-[v0(60)]", views: profileImageView)
        addConstraintWithFormat(format: "V:[v0(60)]", views: profileImageView)
        addConstraint(NSLayoutConstraint.init(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintWithFormat(format: "H:|-82-[v0]|", views: deviderLineView)
        addConstraintWithFormat(format: "V:[v0(1)]|", views: deviderLineView)
        
        
    }
    
    private func setupContainerView(){
        let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        addSubview(containerView)
        
        addConstraintWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintWithFormat(format: "V:[v0(60)]", views: containerView)
        addConstraint(NSLayoutConstraint.init(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImage)
        
        
        containerView.addConstraintWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel,timeLabel)
        containerView.addConstraintWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel,messageLabel)
        
        containerView.addConstraintWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel,hasReadImage)
        containerView.addConstraintWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        containerView.addConstraintWithFormat(format: "V:[v0(24)]|", views: hasReadImage)
        
    }
    
}

extension UIView{
    
    
    func addConstraintWithFormat(format: String, views: UIView...){
        
        var viewsDictionary = [String:UIView]()
        
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

class BaseCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = UIColor.blue
    }
}

extension FriendViewController{
    
}
