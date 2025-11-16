//
//  FoodItem.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import UIKit

struct FoodItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    var imageData: Data?
    let date: Date

    init(
        id: UUID = UUID(),
        name: String,
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        image: UIImage? = nil,
        date: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.date = date
        if let image = image {
            self.imageData = image.jpegData(compressionQuality: 0.8)
        } else {
            self.imageData = nil
        }
    }

    /// Convenience: UIImage from stored imageData (if available)
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}
