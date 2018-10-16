//
//  Friend+CoreDataProperties.swift
//  MyMessenger
//
//  Created by Manikanta Nandam on 16/10/18.
//  Copyright © 2018 Manikanta. All rights reserved.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var name: String?
    @NSManaged public var profileImageName: String?
    @NSManaged public var messages: Message?

}
