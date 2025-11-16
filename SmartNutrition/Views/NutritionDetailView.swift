//
//  NutritionDetailView.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import SwiftUI

struct NutritionDetailView: View {
    let food: FoodItem
    let originalImage: UIImage?
    var onSave: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            if let image = originalImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 220)
                    .cornerRadius(12)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(food.name).font(.title).bold()
                HStack {
                    Text("\(food.calories) kcal").bold()
                    Spacer()
                    Text(String(format: "P: %.1fg", food.protein))
                    Text(String(format: "C: %.1fg", food.carbs))
                    Text(String(format: "F: %.1fg", food.fat))
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            Button(action: {
                onSave?()
            }) {
                Text("Save to Diary")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.primary.opacity(0.1)))
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Nutrition")
    }
}

#Preview {
    NutritionDetailView(food: FoodItem(name: "apple", calories: 95, protein: 0.5, carbs: 25, fat: 0.3), originalImage: .apple)
}
