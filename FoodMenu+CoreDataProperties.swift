//
//  FoodMenu+CoreDataProperties.swift
//  Mr.BreakFast
//
//  Created by Selva Balaji on 3/31/17.
//  Copyright © 2017 Selva Balaji. All rights reserved.
//

import Foundation
import CoreData


extension FoodMenu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodMenu> {
        return NSFetchRequest<FoodMenu>(entityName: "FoodMenu");
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var image: String?

}
