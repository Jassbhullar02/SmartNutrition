//
//  NutritionAPIService.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import UIKit

protocol NutritionAPIServiceProtocol {
    func fetchNutrition(for foodName: String) async throws -> FoodItem
}

final class NutritionAPIService: NutritionAPIServiceProtocol {
    static let shared = NutritionAPIService()

    private var database: [String: (calories: Int, protein: Double, carbs: Double, fat: Double)]

    private init() {
        database = [
            "Apple": (95, 0.5, 25.0, 0.3),
            "Banana": (105, 1.3, 27.0, 0.3),
            "Pizza": (285, 12.0, 36.0, 10.0),
            "Sandwich": (250, 12.0, 30.0, 8.0),
            "Burger": (295, 17.0, 33.0, 12.0)
        ]
    }

    func fetchNutrition(for foodName: String) async throws -> FoodItem {
        // Normalize key
        let key = foodName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized

        // Simulate small delay just like an API call
        try await Task.sleep(nanoseconds: 150_000_000)

        if let entry = database[key] {
            return FoodItem(name: key, calories: entry.calories, protein: entry.protein, carbs: entry.carbs, fat: entry.fat)
        } else {
            // Default fallback values (you can expand / call real API later)
            return FoodItem(name: key, calories: 200, protein: 5.0, carbs: 25.0, fat: 8.0)
        }
    }
}
