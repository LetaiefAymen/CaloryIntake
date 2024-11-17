//
//  MealSelectionView 2.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//


import SwiftUI
import CaloryIntakeCore

struct FoodSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FoodSelectionViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                foodList
                saveButton
            }
            .navigationTitle("\(viewModel.mealName)")
            .toolbar {
                selectedFoodToolbarItem
            }
            .onAppear {
                viewModel.loadItems()
            }
        }
    }
    
    var foodList: some View {
        List(viewModel.foodItems, id: \.id) { foodItem in
            FoodItemRow(viewModel: viewModel, foodItem: foodItem)
        }
        .listStyle(.plain)
    }
    
    var saveButton: some View {
        CapsuleButton(title:"Save") {
            viewModel.saveMeal()
            dismiss()
        }
    }
    
    var selectedFoodToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                dismiss()
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

struct CapsuleButton: View {
    var title: String
    var action: () -> Void = {}
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    var padding: CGFloat = 32
    var fontSize: CGFloat = 18
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(foregroundColor)
                .padding(.horizontal, padding)
                .padding(.vertical, padding / 2)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
                .padding(.horizontal, 20)
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
            selectionButton
        }
        .padding(.vertical, 8)
    }
    
    var selectionButton: some View {
        Button(action: selectAction) {
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
    
    private func selectAction() {
        viewModel.select(foodItem)
        withAnimation(.easeIn(duration: 0.3)) {
            isCheckmarkVisible = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCheckmarkVisible = false
            }
        }
    }
}

struct FoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FoodSelectionView(viewModel: .init(mealName: "Launch"))
    }
}

