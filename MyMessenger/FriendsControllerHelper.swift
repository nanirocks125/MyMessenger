//
//  FriendsControllerHelper.swift
//  MyMessenger
//
//  Created by Manikanta Nandam on 15/10/18.
//  Copyright © 2018 Manikanta. All rights reserved.
//

import UIKit
import CoreData
//}
extension FriendViewController{
    func clearData(){
    
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        do{
//            let entities = ["Friend"]
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            let friends = try context.fetch(fetchRequest) as! [NSManagedObject]
            print("while deleting \(friends.count)")
            
            for friend in friends{
                context.delete(friend)
            }
            
            try context.save()
            
        }catch let err {
            print(err)
            
        }
        
        
    }
    
    func setupData(){
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        
        let friendEntity = NSEntityDescription.entity(forEntityName: "Friend", in: context)!
        let mark = NSManagedObject(entity: friendEntity, insertInto: context) as! Friend
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "mark"
        createMessageWithText(text: "Hello My name is Zuckerberg", friend: mark, minutesAgo: 4, context: context)
        
//
//
        let steveEntity = NSEntityDescription.entity(forEntityName: "Friend", in: context)!
        let steve = NSManagedObject(entity: steveEntity, insertInto: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        
        createMessageWithText(text: "Apple Creates Innovative Products", friend: steve, minutesAgo: 8, context: context)
        
        let gandhiEntity = NSEntityDescription.entity(forEntityName: "Friend", in: context)!
        let gandhi = NSManagedObject(entity: gandhiEntity, insertInto: context) as! Friend
        gandhi.name = "Mahatma Gandhi"
        gandhi.profileImageName = "gandhi"
        
        createMessageWithText(text: "Peace...", friend: gandhi, minutesAgo: 2, context: context)
        
        
        do{
            try context.save()
        }
        catch let err{
            print(err)
        }
        
        loadData()
        
    }
    
    func loadData(){
    
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        do {
            messages = try context.fetch(fetchRequest) as? [Message]
            
            print(messages?.count)
            
        } catch {
            
            print("Failed")
        }
    
    }
    
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext){
        
        print("while adding frined name \(friend.name)")
        let gandhimessageEntity = NSEntityDescription.entity(forEntityName: "Message", in: context)!
        let gandhimessage = NSManagedObject(entity: gandhimessageEntity, insertInto: context) as! Message
        gandhimessage.text = "Peace.. "
        gandhimessage.date = Date().addingTimeInterval(-minutesAgo * 60)
//            .addingTimeInterval(-minutesAgo)
        gandhimessage.friend = friend
        
    }
}
