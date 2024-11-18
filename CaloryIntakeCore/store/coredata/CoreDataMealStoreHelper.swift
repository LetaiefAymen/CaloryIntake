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
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func persist(mealEntry: MealEntry) async -> Bool {
        _ = ManagedMealEntry.from(mealEntry: mealEntry, in: context)
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save meal: \(error)")
            return false
        }
    }
    
    public func retrieveMeals() async -> [MealEntry] {
        let request: NSFetchRequest<ManagedMealEntry> = ManagedMealEntry.fetchRequest()
        
        do {
            let managedMeals = try context.fetch(request)
            return managedMeals.map { $0.toMealEntry() }
        } catch {
            print("Failed to fetch meals: \(error)")
            return []
        }
    }
    
    public func deleteMeals() async -> Bool {
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

public extension NSPersistentContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    static func load(modelName name: String, url: URL?, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        if let url {
            let description = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [description]
        }
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0)
        }
        
        return container
    }
}

public extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
