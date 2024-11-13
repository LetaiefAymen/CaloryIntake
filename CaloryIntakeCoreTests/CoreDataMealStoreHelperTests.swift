//
//  FoodItemsStoreTests.swift
//  FoodItemsStoreTests
//
//  Created by Aymen Letaief on 2024-11-10.
//

import XCTest
import CoreData
@testable import CaloryIntakeCore

protocol MealStoreHelperSpecs {
    func testPersistAndRetrieveMealEntry() async
    func testDeleteMeals() async
    
    func makeSUT() -> MealStoreHelper
}

extension MealStoreHelperSpecs {
    func testPersistAndRetrieveMealEntry() async {
        let sut = makeSUT()
        let brakFastFoodItems = [
            makeFoodItem(name: "Apple"),
            makeFoodItem(name: "Banana")
        ]
        let breakfastEntry = MealEntry(id: UUID(), mealName: "Breakfast", foodItems: brakFastFoodItems)
        
        let launchFoodItems = [
            makeFoodItem(name: "Bread"),
            makeFoodItem(name: "Soup")
        ]
        let launchEntry = MealEntry(id: UUID(), mealName: "Launch", foodItems: launchFoodItems)
        
        let success = await sut.persist(mealEntry: breakfastEntry)
        XCTAssertTrue(success, "Meal entry should be saved successfully")
        let retrievedMeals = await sut.retrieveMeals()
        XCTAssertEqual(retrievedMeals, [breakfastEntry])
        
        let _ = await sut.persist(mealEntry: launchEntry)
        let newRetrievedMeals = await sut.retrieveMeals()
        XCTAssertEqual(newRetrievedMeals, [breakfastEntry, launchEntry])
    }
    
    private func makeFoodItem(name: String) -> FoodItem {
        FoodItem(
            id: UUID(),
            name: name,
            caloryCount: Double.random(in: 0.0...100.0),
            proteinCount: Double.random(in: 0.1...5.0),
            fatCount: Double.random(in: 0.1...3.0)
        )
    }
}


class CoreDataMealStoreHelperTests: XCTestCase, MealStoreHelperSpecs {
    
   var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
    }
     func makeSUT() -> CaloryIntakeCore.MealStoreHelper {
        let storeBundle = Bundle(for: CoreDataMealStoreHelper.self)
        let storeURL = URL(fileURLWithPath: "/dev/null") // In-memory store
        let container = try! NSPersistentContainer.load(modelName: "CaloryIntake", url: storeURL, in: storeBundle)
        context = container.newBackgroundContext()
        return CoreDataMealStoreHelper(context: context)
    }
    
    func testPersistAndRetrieveMealEntryHere() async {
        await testPersistAndRetrieveMealEntry()
    }
    
    func testPersistMealEntry() async {
        let sut = makeSUT()
        
        let foodItems = [
            FoodItem(id: UUID(), name: "Apple", caloryCount: 95, proteinCount: 0.3, fatCount: 0.2),
            FoodItem(id: UUID(), name: "Banana", caloryCount: 105, proteinCount: 1.3, fatCount: 0.3)
        ]
        
        let mealEntry = MealEntry(id: UUID(), mealName: "Breakfast", foodItems: foodItems)
        
        let success = await sut.persist(mealEntry: mealEntry)
        
        XCTAssertTrue(success, "Meal entry should be saved successfully")
        
        let fetchRequest: NSFetchRequest<ManagedMealEntry> = ManagedMealEntry.fetchRequest()
        let results = try? context.fetch(fetchRequest)
        
        XCTAssertEqual(results?.count, 1, "There should be exactly one meal entry saved")
        XCTAssertEqual(results?.first?.name, "Breakfast", "The meal name should match")
        XCTAssertEqual(results?.first?.fooditems?.count, 2, "The meal should have exactly two food items")
    }
    
    func testRetrieveMeals() async {
        let sut = makeSUT()
        
        let foodItems = [
            FoodItem(id: UUID(), name: "Apple", caloryCount: 95, proteinCount: 0.3, fatCount: 0.2),
            FoodItem(id: UUID(), name: "Banana", caloryCount: 105, proteinCount: 1.3, fatCount: 0.3)
        ]
        
        let mealEntry = MealEntry(id: UUID(), mealName: "Breakfast", foodItems: foodItems)
        let _ = await sut.persist(mealEntry: mealEntry)
        
        let retrievedMeals = await sut.retrieveMeals()
        
        XCTAssertEqual(retrievedMeals.count, 1, "There should be exactly one meal retrieved")
        XCTAssertEqual(retrievedMeals.first?.mealName, "Breakfast", "The meal name should match the saved value")
        XCTAssertEqual(retrievedMeals.first?.foodItems.count, 2, "The meal should have exactly two food items")
        
        let firstFoodItem = retrievedMeals.first?.foodItems.first
        XCTAssertEqual(firstFoodItem?.name, "Apple", "The first food item name should be 'Apple'")
        XCTAssertEqual(firstFoodItem?.caloryCount, 95, "The first food item calorie count should be 95")
    }
    
    func testDeleteMeals() async {
        let sut = makeSUT()
        
        let foodItems = [
            FoodItem(id: UUID(), name: "Apple", caloryCount: 95, proteinCount: 0.3, fatCount: 0.2),
            FoodItem(id: UUID(), name: "Banana", caloryCount: 105, proteinCount: 1.3, fatCount: 0.3)
        ]
        
        let mealEntry = MealEntry(id: UUID(), mealName: "Breakfast", foodItems: foodItems)
        let _ = await sut.persist(mealEntry: mealEntry)
        
        let deleteSuccess = await sut.deleteMeals()
        XCTAssertTrue(deleteSuccess, "Meals should be deleted successfully")
        
        let retrievedMeals = await sut.retrieveMeals()
        XCTAssertEqual(retrievedMeals.count, 0, "There should be no meals after deletion")
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
