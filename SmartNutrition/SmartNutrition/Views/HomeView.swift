//
//  HomeView.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showClassifier = false
    @StateObject private var diaryVM = MealDiaryViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("SmartNutrition")
                        .font(.largeTitle).bold()
                    Text("AI food recognition + calorie tracker")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Today's Calories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(diaryVM.totalCaloriesToday()) kcal")
                            .font(.title2).bold()
                    }
                    Spacer()
                    Button(action: { showClassifier = true }) {
                        Label("Scan Food", systemImage: "camera")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(.regularMaterial)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).strokeBorder())

                NavigationLink("Open Meal Diary", destination: MealDiaryView(viewModel: diaryVM))
                    .padding(.top, 8)

                // Add sample foods link here
                NavigationLink("Browse Sample Foods", destination: SampleFoodListView())
                    .padding(.top, 8)

                Spacer()
            }
            .padding()
            .sheet(isPresented: $showClassifier) {
                ClassifierView {
                    diaryVM.loadMeals()
                    showClassifier = false
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
