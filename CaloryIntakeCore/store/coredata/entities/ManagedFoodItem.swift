//
//  FoodItem+CoreDataClass.swift
//  FoodItemsStore
//
//  Created by Aymen Letaief on 2024-11-11.
//
//

import Foundation
import CoreData

@objc(ManagedFoodItem)
class ManagedFoodItem: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var caloryCount: Double
    @NSManaged public var fatCount: Double
    @NSManaged public var name: String
    @NSManaged public var proteinCount: Double
    @NSManaged public var meal: ManagedMealEntry?
}

extension ManagedFoodItem {
    public func toFoodItem() -> FoodItem {
        FoodItem(
            id: id,
            name: name ,
            caloryCount: caloryCount,
            proteinCount: proteinCount,
            fatCount: fatCount
        )
    }
    
    public static func from(foodItem: FoodItem, in context: NSManagedObjectContext) -> ManagedFoodItem {
        let managedEntity = ManagedFoodItem(context: context)
        managedEntity.id = foodItem.id
        managedEntity.name = foodItem.name
        managedEntity.caloryCount = foodItem.caloryCount
        managedEntity.fatCount = foodItem.fatCount
        managedEntity.proteinCount = foodItem.proteinCount
        return managedEntity
    }
}
