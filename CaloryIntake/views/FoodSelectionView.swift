//
//  MealSelectionView 2.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//


import SwiftUI
import CaloryIntakeCore

struct FoodSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: FoodSelectionViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.foodItems, id: \.id) { foodItem in
                    FoodItemRow(viewModel: viewModel, foodItem: foodItem)
                }
                .listStyle(.plain)
                Button("Save") {
                    viewModel.saveMeal()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationTitle("Add Food to \(viewModel.mealName)")
            .onAppear {
                viewModel.loadItems()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("\(viewModel.selectedFoodItems.count)")
                            .bold()
                            .padding(10)
                            .overlay(Circle()
                                .stroke(lineWidth: 2))
                    }
                }
            }
        }
        
    }
}

struct FoodItemRow: View {
    @ObservedObject var viewModel: FoodSelectionViewModel
    var foodItem: FoodItem

    @State private var isCheckmarkVisible = false

    var body: some View {
        HStack(spacing: 12) {
            Text(foodItem.name)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text("\(Int(foodItem.caloryCount)) kcal")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button(action: {
                viewModel.select(foodItem)
                withAnimation(.easeIn(duration: 0.3)) {
                    isCheckmarkVisible = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isCheckmarkVisible = false
                    }
                }
            }) {
                if isCheckmarkVisible {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                        .transition(.scale)
                } else {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}

struct FoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FoodSelectionView(viewModel: .init(mealName: "Launch"))
    }
}

