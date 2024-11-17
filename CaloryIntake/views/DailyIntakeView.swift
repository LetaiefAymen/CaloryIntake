//
//  DailyIntakeView.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//
import SwiftUI
import CaloryIntakeCore

struct DailyIntakeView: View {
    
    @State var isPresented: Bool = false
    @ObservedObject var viewModel: DailyIntakeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    cardView(
                        title: "Calories",
                        value: "\(viewModel.totalCalories) kcal",
                        color: .blue
                    )
                    cardView(
                        title: "Proteins",
                        value: "\(viewModel.totalProteins) g",
                        color: .green
                    )
                    cardView(
                        title: "Fats",
                        value: "\(viewModel.totalFats) g",
                        color: .yellow
                    )
                }
                .padding(.top, 30)
            }
            .navigationTitle("Today's Intake")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarButton
                }
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                viewModel.loadData()
            }, content: {
                MealSelectionView()
            })
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    @ViewBuilder private func cardView(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title2)
            Text(value)
                .font(.title)
                .bold()
        }
        .padding(40)
        .background(color)
        .cornerRadius(30)
    }
    
    var toolbarButton: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            Text("Add Meal")
                .font(.title3)
        }
    }
}

#Preview {
    DailyIntakeView(viewModel: DailyIntakeViewModel(
        helper: InMemoryMealStoreHelper(),
        totalCalories: 2000,
        totalFats: 36,
        totalProteins: 100
    ))
}
