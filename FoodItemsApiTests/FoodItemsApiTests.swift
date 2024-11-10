//
//  FoodItemsApiTests.swift
//  FoodItemsApiTests
//
//  Created by Aymen Letaief on 2024-11-10.
//

import XCTest
@testable import FoodItemsApi

final class FoodItemsApiTests: XCTestCase {
    
    func testSUT_isNotNil() {
        let sut = makeSUT()
        XCTAssertNotNil(sut)
    }

    private func makeSUT() -> FoodItemsLoader {
        RemoteFoodItemsLoader()
    }

}
