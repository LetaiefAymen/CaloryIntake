//
//  FoodItemsStoreTests.swift
//  FoodItemsStoreTests
//
//  Created by Aymen Letaief on 2024-11-10.
//

import XCTest
import CoreData
@testable import CaloryIntakeCore

class CoreDataMealStoreHelperTests: XCTestCase, MealStoreHelperSpecs {
    
    func testPersistAndRetrieveMealEntry() async {
        let sut = makeSUT()
        await assertSUTPersistAndRetrieveMealEntryCorrectly(sut: sut)
    }
    
    func testDeleteMeals() async {
        let sut = makeSUT()
        await assertSUTDeleteMealsCorrectly(sut: sut)
    }
    
    private func makeSUT() -> CaloryIntakeCore.MealStoreHelper {
        let storeBundle = Bundle(for: CoreDataMealStoreHelper.self)
        let storeURL = URL(fileURLWithPath: "/dev/null") // In-memory store
        let container = try! NSPersistentContainer.load(modelName: "CaloryIntake", url: storeURL, in: storeBundle)
        let context = container.newBackgroundContext()
        return CoreDataMealStoreHelper(context: context)
    }
    
}

private extension NSPersistentContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0)
        }
        
        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
