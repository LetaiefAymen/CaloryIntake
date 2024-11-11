//
//  ContentView.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 2024-11-10.
//

import SwiftUI
import CaloryIntakeCore
struct ContentView: View {
    @ObservedObject
    var viewModel: CaloryIntakeViewModel
    
    var body: some View {
        contentView
            .onAppear {
                viewModel.loadItems()
            }
    }
    
    var contentView: some View {
        NavigationView {
            VStack {
                if viewModel.foodItems.isEmpty {
                    ProgressView("Loading...")
                } else {
                    List(viewModel.foodItems, id: \.name) { foodItem in
                        FoodItemRow(foodItem: foodItem)
                    }
                }
            }
            .navigationTitle("Calorie Tracker")
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
                Text("Calories: \(Int(foodItem.caloryCount)) kcal")
                Text("Protein: \(foodItem.proteinCount, specifier: "%.1f") g")
                Text("Fat: \(foodItem.fatCount, specifier: "%.1f") g")
                
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: CaloryIntakeViewModel())
    }
}
