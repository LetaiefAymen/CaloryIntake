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
public class ManagedMealEntry: NSManagedObject {

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var fooditems: NSSet?
}

extension ManagedMealEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedMealEntry> {
        return NSFetchRequest<ManagedMealEntry>(entityName: "ManagedMealEntry")
    }
}

// MARK: Generated accessors for fooditems
extension ManagedMealEntry {

    @objc(addFooditemsObject:)
    @NSManaged public func addToFooditems(_ value: ManagedFoodItem)

    @objc(removeFooditemsObject:)
    @NSManaged public func removeFromFooditems(_ value: ManagedFoodItem)

    @objc(addFooditems:)
    @NSManaged public func addToFooditems(_ values: NSSet)

    @objc(removeFooditems:)
    @NSManaged public func removeFromFooditems(_ values: NSSet)

}
