//
//  ChatLogController.swift
//  MyMessenger
//
//  Created by Manikanta Nandam on 16/10/18.
//  Copyright © 2018 Manikanta. All rights reserved.
//

import UIKit
import Foundation

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    private var cellId = "messageCell"
    private var messages: [Message]?
    
    let topBorderView: UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        
        return view
        
    }()
    
    
    let messageInputContainerView:UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
        
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    let messageTextField: UITextField = {
       let textField = UITextField()
        textField.attributedPlaceholder =  NSAttributedString(string: "Please Type Message", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
        return textField
        
    }()
    
    
    let sendButton: UIButton = {
       let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 137/255, blue: 247/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func sendMessage(){
        print(messageTextField.text)
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = delegate.persistentContainer.viewContext
        
        let message = FriendViewController.createMessageWithText(text: messageTextField.text!, isSender: true, friend: self.friend!, minutesAgo: 0, context: context)
        
        messages?.append(message)
        
        do{
            try context.save()
        }catch let err{
            print(err)
        }
        
        let item = messages!.count - 1
        let indexpath = IndexPath(row: item, section: 0)
        
        collectionView.insertItems(at: [indexpath])
        self.collectionView.scrollToItem(at: indexpath, at: .bottom, animated: true)
        messageTextField.text = nil
        
    }
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ChatLogCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        view.addSubview(messageInputContainerView)
        messageInputContainerView.addSubview(messageTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        
        
        messageInputContainerView.addConstraintWithFormat(format: "H:|-8-[v0][v1(60)]|", views: messageTextField,sendButton)
        messageInputContainerView.addConstraintWithFormat(format: "V:|[v0]|", views: messageTextField)
        messageInputContainerView.addConstraintWithFormat(format: "V:|[v0]|", views: sendButton)
        messageInputContainerView.addConstraintWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
        
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraintWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintWithFormat(format: "V:[v0(50)]", views: messageInputContainerView)
        view.addConstraint(bottomConstraint!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50)
        
        let indexpath = IndexPath(row: (self.messages?.count)! - 1, section: 0)
        self.collectionView.scrollToItem(at: indexpath, at: .bottom, animated: true)

    }
    
    @objc func handleKeyBoardNotification(notification: Notification) {
        
        print("keyboard event")
        
        if let userinfo = notification.userInfo{
            let keyboardFrame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            
            bottomConstraint?.constant = isKeyboardShowing ?  -(keyboardFrame?.height)! : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                
            }) { (completed) in
                let indexpath = IndexPath(row: (self.messages?.count)! - 1, section: 0)
                self.collectionView.scrollToItem(at: indexpath, at: .bottom, animated: true)
                
            }
            
            
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count{
            return count
        }
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCell
        cell.messageTextView.text = messages?[indexPath.row].text
        
        if let messageText = messages?[indexPath.row].text{
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            cell.profileImageView.image = UIImage(named: (messages?[indexPath.row].friend!.profileImageName)!)
           
            if let isSender = messages?[indexPath.row].isSender{
                 cell.profileImageView.isHidden = isSender
                if !isSender{
                    cell.messageTextView.frame = CGRect(x: 60, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    cell.chatBubbleView.frame = CGRect(x: 60, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                   
                    
                }else{
                    cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    cell.chatBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    cell.chatBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 247/255, alpha: 1)
                    cell.messageTextView.textColor = .white
                    
                }
            }
            
           
            
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.row].text{
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            print("for size \(view.frame.width)")
            return CGSize(width: view.frame.width + 20, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
    
    
}

class ChatLogCell: BaseCell{
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let messageTextView: UITextView = {
        let textview = UITextView()
        textview.text = "My Message text"
        textview.backgroundColor = .clear
        textview.isEditable = false
        
        textview.font = UIFont.systemFont(ofSize: 18)
        return textview
    }()
    
    let chatBubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    
    override func setupView() {
        addSubview(chatBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintWithFormat(format: "H:|-16-[v0(30)]", views: profileImageView)
        addConstraintWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        
    }
}
