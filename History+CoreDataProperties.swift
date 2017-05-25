//
//  History+CoreDataProperties.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/4/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History");
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var quantity: String?
    @NSManaged public var time: NSDate?

}
