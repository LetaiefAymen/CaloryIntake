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
    @State var appComposer: AppComposer = .init()
    
    var body: some Scene {
        WindowGroup {
            DailyIntakeView(viewModel: .init(helper: appComposer.composeStoreHelper()))
                .environmentObject(appComposer)
        }
    }
}

extension InMemoryMealStoreHelper: @retroactive ObservableObject {
    
}
