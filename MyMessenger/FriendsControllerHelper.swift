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
        
        createMessageWithText(text: "Good Morning", friend: steve, minutesAgo: 8, context: context)
        createMessageWithText(text: "Hello How are you..", friend: steve, minutesAgo: 8, context: context)
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
//                messages?.append(contentsOf: <#T##Sequence#>)
                
            } catch {
                
                print("Failed")
            }
            
        }
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
    
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext){
        let gandhimessageEntity = NSEntityDescription.entity(forEntityName: "Message", in: context)!
        let gandhimessage = NSManagedObject(entity: gandhimessageEntity, insertInto: context) as! Message
        gandhimessage.text = text
        gandhimessage.date = Date().addingTimeInterval(-minutesAgo * 60)
        //            .addingTimeInterval(-minutesAgo)
        gandhimessage.friend = friend
        
    }
}
