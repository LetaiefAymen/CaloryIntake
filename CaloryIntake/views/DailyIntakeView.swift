//
//  DailyIntakeView.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//
import SwiftUI
import CaloryIntakeCore

struct DailyIntakeView: View {
    
    let viewModel: DailyIntakeViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Today's Intake")
                    .font(.largeTitle)
                    .bold()
                VStack(spacing: 10) {
                    Text("Calories")
                        .bold()
                    Text("\(viewModel.totalCalories) kcal")
                        .font(.title)
                    Text("Proteins")
                        .bold()
                    Text("\(viewModel.totalProteins,specifier: "%.1f") g")
                        .font(.title)
                    Text("Fats")
                        .bold()
                    Text("\(viewModel.totalFats,specifier: "%.1f") g")
                        .font(.title)
                }
            }
            .padding()
            .navigationTitle("Calorie counter")
        }
    }
}

#Preview {
    DailyIntakeView(viewModel: DailyIntakeViewModel(
        helper: InMemoryMealStoreHelper(),
        totalCalories: 2000,
        totalFats: 36,
        totalProteins: 100
    )
    )
}
