//
//  CaloryIntakeApp.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 2024-11-10.
//

import SwiftUI
import CaloryIntakeCore

@main
struct CaloryIntakeApp: App {
    @State var storeHelper: InMemoryMealStoreHelper = .init()
    
    var body: some Scene {
        WindowGroup {
            DailyIntakeView(viewModel: .init(helper: storeHelper))
                .environmentObject(storeHelper)
        }
    }
}

extension InMemoryMealStoreHelper: @retroactive ObservableObject {
    
}
