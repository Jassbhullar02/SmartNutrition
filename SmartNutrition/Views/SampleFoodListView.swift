//
//  SampleFoodListView.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import SwiftUI

let sampleFoods: [FoodItem] = [
    FoodItem(name: "apple", calories: 95, protein: 0.5, carbs: 25, fat: 0.3),
    FoodItem(name: "banana", calories: 105, protein: 1.3, carbs: 27, fat: 0.3),
    FoodItem(name: "burger", calories: 295, protein: 17, carbs: 33, fat: 12),
    FoodItem(name: "sandwich", calories: 250, protein: 12, carbs: 30, fat: 8),
    FoodItem(name: "pizza", calories: 285, protein: 12, carbs: 36, fat: 10)
]

struct SampleFoodListView: View {
    var body: some View {
        List(sampleFoods, id: \.name) { item in
            NavigationLink {
                NutritionDetailView(
                    food: item,
                    originalImage: UIImage(named: item.name),
                    onSave: nil
                )
            } label: {
                HStack(spacing: 16) {

                    // SAFE IMAGE LOAD
                    if let img = UIImage(named: item.name) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                    } else {
                        Rectangle()
                            .fill(.secondary.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                            .overlay(
                                Text("No Img")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            )
                    }

                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)

                        Text("\(item.calories) kcal")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("Sample Foods")
    }
}

#Preview {
    SampleFoodListView()
}
