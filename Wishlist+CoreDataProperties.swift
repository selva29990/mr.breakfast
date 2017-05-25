//
//  Wishlist+CoreDataProperties.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 4/3/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import Foundation
import CoreData


extension Wishlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wishlist> {
        return NSFetchRequest<Wishlist>(entityName: "Wishlist");
    }

    @NSManaged public var itemname: String?
    @NSManaged public var itemimage: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var itemprice: String?

}
