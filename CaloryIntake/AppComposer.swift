//
//  AppComposer.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 18.11.24.
//

import Foundation
import CaloryIntakeCore

final class AppComposer: ObservableObject {
    
    private let storeHelper: MealStoreHelper
    
    init() {
        storeHelper = InMemoryMealStoreHelper()
    }
    
    func composeFoodItemLoader() -> FoodItemsLoader {
        RemoteFoodItemsLoader(
            url: AppEnvironment.shared.foodItemsUrl,
            client: URLSessionHTTPClient(
                session: URLSession(configuration: .default)
            )
        )
    }
    
    func composeStoreHelper() -> MealStoreHelper {
        storeHelper
    }
    
}
