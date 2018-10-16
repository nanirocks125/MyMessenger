//
//  Message+CoreDataProperties.swift
//  MyMessenger
//
//  Created by Manikanta Nandam on 16/10/18.
//  Copyright © 2018 Manikanta. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}
