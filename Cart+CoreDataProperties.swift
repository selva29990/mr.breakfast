//
//  Cart+CoreDataProperties.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 3/31/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart");
    }

    @NSManaged public var itemname: String?
    @NSManaged public var itemprice: String?
    @NSManaged public var itemquantity: String?
    @NSManaged public var userid: String?

}
