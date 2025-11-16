//
//  PersistenceService.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import CoreData
import UIKit

// MARK: - PersistenceService (Core Data Manager)
final class PersistenceService {
    
    static let shared = PersistenceService()
    let container: NSPersistentContainer

    // MARK: - Init
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SmartNutritionModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("❌ Core Data store failed: \(error)")
            }
        }

        // If conflict → latest values overwrite old
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Save context helper
    func saveContext() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("❌ Failed saving context: \(error)")
        }
    }

    // MARK: - Create Meal using FoodItem (internal usage)
    func createMeal(from item: FoodItem) {
        let context = container.viewContext

        let meal = MealEntity(context: context)
        meal.id = item.id
        meal.name = item.name
        meal.calories = Double(item.calories)
        meal.protein = item.protein
        meal.carbs = item.carbs
        meal.fat = item.fat
        meal.date = item.date
        meal.imageData = item.imageData

        saveContext()
    }

    // MARK: - Add Meal (simple wrapper for ViewModel UI usage)
    func addMeal(foodName: String, calories: Int, imageData: Data?) {

        let newItem = FoodItem(
            name: foodName,
            calories: calories,
            protein: 0.0,
            carbs: 0.0,
            fat: 0.0,
            image: imageData.flatMap { UIImage(data: $0) }
        )

        createMeal(from: newItem)
    }

    // MARK: - Fetch sorted meals
    func fetchMeals() -> [MealEntity] {
        let request: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        
        // Latest first
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MealEntity.date, ascending: false)
        ]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("❌ Fetch meals error: \(error)")
            return []
        }
    }

    // MARK: - Delete meal
    func deleteMeal(_ meal: MealEntity) {
        container.viewContext.delete(meal)
        saveContext()
    }
}
