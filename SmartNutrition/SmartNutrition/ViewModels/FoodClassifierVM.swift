//
//  FoodClassifierVM.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import UIKit

@MainActor
final class FoodClassifierViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var predictions: [(String, Double)] = []
    @Published var selectedFood: FoodItem?
    @Published var errorMessage: String?

    private let classifier = MLClassifierService.shared
    private let nutritionService: NutritionAPIServiceProtocol

    init(nutritionService: NutritionAPIServiceProtocol = NutritionAPIService.shared) {
        self.nutritionService = nutritionService
    }

    func classify(image: UIImage) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let results = try await classifier.classify(image: image)
                self.predictions = results
                if let top = results.first {
                    let food = try await nutritionService.fetchNutrition(for: top.label)
                    self.selectedFood = food
                }
                isLoading = false
            } catch {
                print("Classification error: \(error)")
                errorMessage = "Failed to classify image"
                isLoading = false
            }
        }
    }

    func saveSelectedFood(with image: UIImage?) {
        guard let item = selectedFood else { return }
        var mutable = item
        if let image = image {
            mutable = FoodItem(id: item.id, name: item.name, calories: item.calories, protein: item.protein, carbs: item.carbs, fat: item.fat, image: image, date: item.date)
        }
        PersistenceService.shared.createMeal(from: mutable)
    }
}
