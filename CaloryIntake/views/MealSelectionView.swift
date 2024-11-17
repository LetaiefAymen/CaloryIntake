//
//  MealSelectionView.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//


import SwiftUI
import CaloryIntakeCore

enum Meal: Identifiable {
    case breakfast
    case launch
    case dinner
    case snack
    
    var id: String { self.description }

    var description: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .launch: return "Launch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        }
    }
}

struct MealSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMeal: Meal?
    @State private var isPresentingFoodSelection = false
    @EnvironmentObject private var storeHelper: InMemoryMealStoreHelper
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Meal")
                .font(.title2)
                .bold()
            
            ForEach([Meal.breakfast, Meal.launch, Meal.dinner, Meal.snack], id: \.self) { meal in
                Button(action: {
                    selectedMeal = meal
                    isPresentingFoodSelection = true
                }) {
                    Text(meal.description)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .sheet(item: $selectedMeal) { meal in
            FoodSelectionView(viewModel: .init(mealName: meal.description, mealStoreHelper: storeHelper))
        }
    }
}


struct MealSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MealSelectionView()
    }
}
