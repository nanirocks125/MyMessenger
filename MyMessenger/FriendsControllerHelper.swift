//
//  FriendsControllerHelper.swift
//  MyMessenger
//
//  Created by Manikanta Nandam on 15/10/18.
//  Copyright © 2018 Manikanta. All rights reserved.
//

import Foundation


class Friend: NSObject{
    var name: String?
    var profileImageName: String?
}

class Message: NSObject{
    var text: String?
    var date: Date?

    var friend: Friend?
}
extension FriendViewController{
    func setupData(){
        
        let mark = Friend()
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "mark"
        
        let message = Message()
        message.text = "Hello My name is zuckerberg... nice to meet you"
        message.date = Date()
        message.friend = mark
        
        messages = [message]
        
    }
}
