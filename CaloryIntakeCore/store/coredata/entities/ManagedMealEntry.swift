//
//  MealEntry+CoreDataClass.swift
//  FoodItemsStore
//
//  Created by Aymen Letaief on 2024-11-11.
//
//

import Foundation
import CoreData

@objc(ManagedMealEntry)
class ManagedMealEntry: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var fooditems: NSOrderedSet?
}

extension ManagedMealEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedMealEntry> {
        return NSFetchRequest<ManagedMealEntry>(entityName: "ManagedMealEntry")
    }
}

extension ManagedMealEntry {
    public func toMealEntry() -> MealEntry {
        let foodItemsArray = (fooditems?.array as? [ManagedFoodItem])?.map { $0.toFoodItem() } ?? []
        return MealEntry(id: id, mealName: name, foodItems: foodItemsArray)
    }
    
    public static func from(mealEntry: MealEntry, in context: NSManagedObjectContext) -> ManagedMealEntry {
        let managedMeal = ManagedMealEntry(context: context)
        managedMeal.id = mealEntry.id
        managedMeal.name = mealEntry.mealName
        managedMeal.fooditems = NSOrderedSet(array: mealEntry.foodItems.map { ManagedFoodItem.from(foodItem: $0, in: context) })
        return managedMeal
    }
}
