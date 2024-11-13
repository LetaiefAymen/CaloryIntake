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
    var body: some Scene {
        WindowGroup {
            DailyIntakeView(viewModel: .init(helper: InMemoryMealStoreHelper()))
        }
    }
}
