//
//  AppComposer.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 18.11.24.
//

import Foundation
import CaloryIntakeCore
import CoreData

final class AppComposer: ObservableObject {
    
    private let storeHelper: MealStoreHelper
    
    init() {
        storeHelper = AppComposer.makeCoreDataStoreHelper()
        // In order to use InMemoryStoreHelper, use this instead
        // storeHelper = InMemoryMealStoreHelper()
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
    
    private static func makeCoreDataStoreHelper() -> MealStoreHelper {
        let storeBundle = Bundle(for: CoreDataMealStoreHelper.self)
        let container = try! NSPersistentContainer.load(modelName: "CaloryIntake", url: nil, in: storeBundle)
        let context = container.newBackgroundContext()
        return CoreDataMealStoreHelper(context: context)
    }
    
}
