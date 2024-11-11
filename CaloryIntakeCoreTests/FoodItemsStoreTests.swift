//
//  FoodItemsStoreTests.swift
//  FoodItemsStoreTests
//
//  Created by Aymen Letaief on 2024-11-10.
//

import XCTest
@testable import FoodItemsStore

class FoodItemsStoreTests: XCTestCase {

    func testSUT_isNotNil() {
        let sut = makeSUT()
        XCTAssertNotNil(sut)
    }
    
    private func makeSUT() -> CoreDataMealStoreHelper {
        CoreDataMealStoreHelper()
    }

}
