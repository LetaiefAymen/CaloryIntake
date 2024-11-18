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
