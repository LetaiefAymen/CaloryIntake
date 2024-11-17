//
//  MealSelectionView 2.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//


import SwiftUI
import CaloryIntakeCore

struct FoodSelectionView: View {
    var meal: String
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = CaloryIntakeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.foodItems, id: \.name) { foodItem in
                    FoodItemRow(foodItem: foodItem)
                }
                Button("Save") {
                    // TODO Aymen: Add logic here
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationTitle("Add Food to \(meal)")
            .onAppear {
                viewModel.loadItems()
            }
        }
    }
}

struct FoodItemRow: View {
    var foodItem: FoodItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(foodItem.name)
                .font(.headline)
            HStack {
                Text("Calories: \(foodItem.caloryCount, specifier: "%.1f") kcal")
                Text("Protein: \(foodItem.proteinCount, specifier: "%.1f") g")
                Text("Fat: \(foodItem.fatCount, specifier: "%.1f") g")
                
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct FoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FoodSelectionView(meal: "Launch")
    }
}

