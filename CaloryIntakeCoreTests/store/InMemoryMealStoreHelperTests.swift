//
//  InMemoryMealStoreHelperTests.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//

import XCTest
import CoreData
@testable import CaloryIntakeCore

class InMemoryMealStoreHelperTests: XCTestCase, MealStoreHelperSpecs {
    
    func testPersistAndRetrieveMealEntry() async {
        let sut = makeSUT()
        await assertSUTPersistAndRetrieveMealEntryCorrectly(sut: sut)
    }
                                  
    func testDeleteMeals() async {
        let sut = makeSUT()
        await assertSUTDeleteMealsCorrectly(sut: sut)
    }
    
    private func makeSUT() -> CaloryIntakeCore.MealStoreHelper {
        InMemoryMealStoreHelper()
    }
    
}
