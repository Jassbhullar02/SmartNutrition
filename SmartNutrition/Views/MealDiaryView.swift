//
//  MealDiaryView.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import SwiftUI

struct MealDiaryView: View {
    @ObservedObject var viewModel: MealDiaryViewModel

    var body: some View {
        List {
            Section(header: Text("Summary")) {
                HStack {
                    Text("Today's Calories")
                    Spacer()
                    Text("\(viewModel.totalCaloriesToday()) kcal").bold()
                }
            }

            Section(header: Text("Meals")) {
                ForEach(viewModel.meals, id: \.id) { meal in
                    HStack(spacing: 12) {
                        if let data = meal.imageData, let ui = UIImage(data: data) {
                            Image(uiImage: ui)
                                .resizable()
                                .frame(width: 56, height: 56)
                                .cornerRadius(8)
                        } else {
                            Rectangle()
                                .fill(.secondary.opacity(0.1))
                                .frame(width: 56, height: 56)
                                .cornerRadius(8)
                                .overlay(Text("No\nImg").font(.caption).multilineTextAlignment(.center))
                        }
                        VStack(alignment: .leading) {
                            Text(meal.name ?? "Unknown").bold()
                            Text("\(Int(meal.calories)) kcal • \(meal.protein)g P").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(meal.date ?? Date(), style: .date).font(.caption)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Meal Diary")
        .toolbar {
            EditButton()
        }
        .onAppear {
            viewModel.loadMeals()
        }
    }
}

//#Preview {
//    MealDiaryView()
//}
