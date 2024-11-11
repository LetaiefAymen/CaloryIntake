//
//  CoreDataMealStoreHelper.swift
//  CaloryIntakeCore
//
//  Created by Aymen Letaief on 2024-11-11.
//

import Foundation
import CoreData

public class CoreDataMealStoreHelper: MealStoreHelper {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func persist(mealEntry: MealEntry) async -> Bool {
        _ = ManagedMealEntry.from(mealEntry: mealEntry, in: context)
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save meal: \(error)")
            return false
        }
    }
    
    func retrieveMeals() async -> [MealEntry] {
        let request: NSFetchRequest<ManagedMealEntry> = ManagedMealEntry.fetchRequest()
        
        do {
            let managedMeals = try context.fetch(request)
            return managedMeals.map { $0.toMealEntry() }
        } catch {
            print("Failed to fetch meals: \(error)")
            return []
        }
    }
    
    func deleteMeals() async -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = ManagedMealEntry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            return true
        } catch {
            print("Failed to delete meals: \(error)")
            return false
        }
    }
}
