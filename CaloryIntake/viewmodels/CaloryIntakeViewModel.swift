//
//  CaloryIntakeViewModel.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 2024-11-10.
//

import Foundation
import CaloryIntakeCore

final class CaloryIntakeViewModel: ObservableObject {
    
    let loader: RemoteFoodItemsLoader
    @Published
    var foodItems: [FoodItem] = []
    
    init(loader: RemoteFoodItemsLoader = RemoteFoodItemsLoader(
            url: AppEnvironment.shared.foodItemsUrl,
            client: URLSessionHTTPClient(
                session: URLSession(configuration: .default)
            )
        )
    ) {
        self.loader = loader
    }
    
    func loadItems() {
        Task { @MainActor in
            do {
                let remoteFoodItems = try await loader.loadFoodItems()
                foodItems = remoteFoodItems.map({ $0.toFoodItem() })
                print(foodItems)
            } catch {
                print("Error happened: \(error.localizedDescription)")
            }
        }
    }
}
