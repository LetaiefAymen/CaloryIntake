//
//  FoodItem+CoreDataClass.swift
//  FoodItemsStore
//
//  Created by Aymen Letaief on 2024-11-11.
//
//

import Foundation
import CoreData

@objc(LocalFoodItem)
public class ManagedFoodItem: NSManagedObject {

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var caloryCount: NSDecimalNumber?
    @NSManaged public var fatCount: NSDecimalNumber?
    @NSManaged public var proteinCount: NSDecimalNumber?
    @NSManaged public var meal: ManagedMealEntry?
}

extension ManagedFoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedFoodItem> {
        return NSFetchRequest<ManagedFoodItem>(entityName: "ManagedFoodItem")
    }
}

extension ManagedFoodItem {
    public func toFoodItem() -> FoodItem {
        FoodItem(
            id: id!,
            name: name!,
            caloryCount: Double(truncating: caloryCount!),
            proteinCount: Double(truncating: proteinCount!),
            fatCount: Double(truncating: fatCount!)
        )
    }
    
    public static func from(foodItem: FoodItem, in context: NSManagedObjectContext) -> ManagedFoodItem {
        let managedEntity = ManagedFoodItem(context: context)
        managedEntity.id = foodItem.id
        return managedEntity
    }
}
