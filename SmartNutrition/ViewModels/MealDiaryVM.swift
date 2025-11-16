//
//  MealDiaryVM.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import CoreData
import SwiftUI

/// MealDiaryViewModel
/// Responsible for:
/// - Adding meals
/// - Fetching all meals
/// - Deleting meals
/// - Holding UI state (name, calories, image)
/// This is the correct MVVM-layer for the app.
@MainActor
final class MealDiaryViewModel: ObservableObject {

    // MARK: - Published (UI state)
    @Published var meals: [MealEntity] = []
    @Published var foodName: String = ""
    @Published var calories: String = ""
    @Published var selectedImage: UIImage? = nil

    private let persistence = PersistenceService.shared

    // MARK: - Init
    init() {
        loadMeals()
    }

    // MARK: - Fetch All Meals
    func loadMeals() {
        meals = persistence.fetchMeals()
    }

    // MARK: - Save New Meal
    func saveMeal() {

        guard !foodName.isEmpty else {
            print("Food name missing")
            return
        }

        guard let cal = Int(calories) else {
            print("Calories must be a number")
            return
        }

        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        persistence.addMeal(
            foodName: foodName,
            calories: cal,
            imageData: imageData
        )

        // Reset UI
        foodName = ""
        calories = ""
        selectedImage = nil

        // Refresh list
        loadMeals()
    }

    // MARK: - Delete Meal
    func deleteMeal(_ meal: MealEntity) {
        persistence.deleteMeal(meal)
        loadMeals()
    }

    // MARK: - Swipe delete support
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let meal = meals[index]
            deleteMeal(meal)
        }
    }

    // MARK: - Calories Today
    func totalCaloriesToday() -> Int {
        let calendar = Calendar.current
        let todayMeals = meals.filter { meal in
            guard let date = meal.date else { return false }
            return calendar.isDateInToday(date)
        }
        return todayMeals.reduce(0) { $0 + Int($1.calories) }
    }
}
