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
        
        
        let markEntity = NSEntityDescription.entity(forEntityName: "Friend", in: context)!
        let mark = NSManagedObject(entity: markEntity, insertInto: context) as! Friend
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "mark"
        FriendViewController.createMessageWithText(text: "Hello My name is Zuckerberg", isSender: true, friend: mark, minutesAgo: 4, context: context)
        
        let steveEntity = NSEntityDescription.entity(forEntityName: "Friend", in: context)!
        let steve = NSManagedObject(entity: steveEntity, insertInto: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        
        FriendViewController.createMessageWithText(text: "Good Morning", isSender: true, friend: steve, minutesAgo: 8, context: context)
        FriendViewController.createMessageWithText(text: "Hello How are you.. Hope you are having a nice morning ", isSender: false, friend: steve, minutesAgo: 8, context: context)
        FriendViewController.createMessageWithText(text: "Apple Creates Innovative Products.. we have variety of products apple intrduces new 3 model iphone XS.XR. XSMax. are you interested in buying brand new mobile", isSender: true, friend: steve, minutesAgo: 8, context: context)
        
        
        FriendViewController.createMessageWithText(text: "Good Morning", isSender: true, friend: steve, minutesAgo: 8, context: context)
        FriendViewController.createMessageWithText(text: "Hello How are you.. Hope you are having a nice morning ", isSender: false, friend: steve, minutesAgo: 8, context: context)
        FriendViewController.createMessageWithText(text: "Apple Creates Innovative Products.. we have variety of products apple intrduces new 3 model iphone XS.XR. XSMax. are you interested in buying brand new mobile", isSender: true, friend: steve, minutesAgo: 8, context: context)
        
        
        FriendViewController.createMessageWithText(text: "Good Morning", isSender: true, friend: steve, minutesAgo: 8, context: context)
        FriendViewController.createMessageWithText(text: "Hello How are you.. Hope you are having a nice morning ", isSender: false, friend: steve, minutesAgo: 8, context: context)
        FriendViewController.createMessageWithText(text: "Apple Creates Innovative Products.. we have variety of products apple intrduces new 3 model iphone XS.XR. XSMax. are you interested in buying brand new mobile", isSender: true, friend: steve, minutesAgo: 8, context: context)
        
        let gandhiEntity = NSEntityDescription.entity(forEntityName: "Friend", in: context)!
        let gandhi = NSManagedObject(entity: gandhiEntity, insertInto: context) as! Friend
        gandhi.name = "Mahatma Gandhi"
        gandhi.profileImageName = "gandhi"
        
        FriendViewController.createMessageWithText(text: "Peace...", isSender: true, friend: gandhi, minutesAgo: 60 * 24 , context: context)
        
        let hillaryEntity = NSEntityDescription.entity(forEntityName: "Friend", in: context)!
        let hillary = NSManagedObject(entity: hillaryEntity, insertInto: context) as! Friend
        hillary.name = "Hillary Clinton"
        hillary.profileImageName = "hillary"
        
        FriendViewController.createMessageWithText(text: "Please vote for me", isSender: true, friend: hillary, minutesAgo: 60 * 24 * 8 , context: context)
        
        
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
        messages = [Message]()
        guard let friends = fetchFriends() else {return}
        for friend in friends{
            
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "friend.name == %@", friend.name!)
            fetchRequest.fetchLimit = 1
            
            do {
                let fetchedMessages = try context.fetch(fetchRequest) as? [Message]
                messages = messages! + fetchedMessages!
                
                
            } catch {
                
                print("Failed")
            }
            
        }
        
        messages = messages?.sorted(by: { (mes1, mes2) -> Bool in
            return (mes1.date?.compare(mes2.date!) == .orderedDescending)
        })
    }
    
    private func fetchFriends() -> [Friend]?{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        do {
            return try context.fetch(fetchRequest) as? [Friend]
            
            
        } catch {
            return nil
        }
    }
    
    
    static public func createMessageWithText(text: String, isSender:Bool, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) -> Message{
        let gandhimessageEntity = NSEntityDescription.entity(forEntityName: "Message", in: context)!
        let gandhimessage = NSManagedObject(entity: gandhimessageEntity, insertInto: context) as! Message
        gandhimessage.text = text
        gandhimessage.date = Date().addingTimeInterval(-minutesAgo * 60)
        //            .addingTimeInterval(-minutesAgo)
        gandhimessage.friend = friend
        gandhimessage.isSender = isSender
        return gandhimessage
    }
}
