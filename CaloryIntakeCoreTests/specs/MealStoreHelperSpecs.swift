//
//  MealStoreHelperTestSpecs.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//

import Foundation
import XCTest
@testable import CaloryIntakeCore

protocol MealStoreHelperSpecs {
    func testPersistAndRetrieveMealEntry() async
    func testDeleteMeals() async
}

extension MealStoreHelperSpecs {
    func assertSUTPersistAndRetrieveMealEntryCorrectly(sut: MealStoreHelper) async {
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
    
    func assertSUTDeleteMealsCorrectly(sut: MealStoreHelper) async {
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
        let _ = await sut.persist(mealEntry: breakfastEntry)
        let _ = await sut.persist(mealEntry: launchEntry)
        
        let success = await sut.deleteMeals()
        XCTAssertTrue(success, "Meal entries should be deleted successfully")
        let retrievedMeals = await sut.retrieveMeals()
        XCTAssertEqual(retrievedMeals, [])
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
