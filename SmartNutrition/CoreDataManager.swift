//
//  CoreDataManager.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import CoreData

/// CoreDataManager
/// This is the singleton class that manages the Core Data stack.
/// It provides SAVE, FETCH, DELETE functionality for MealEntity.
final class CoreDataManager {

    // MARK: - Singleton
    static let shared = CoreDataManager()
    private init() {}

    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmartNutritionModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()

    // MARK: - Context
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Save Context
    /// Saves the current state of the context to the persistent store.
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Error saving Core Data: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Create Meal Entry
    /// Creates a new MealEntity and saves it.
    func addMeal(foodName: String, calories: Int, imageData: Data?) {
        let meal = MealEntity(context: context)
        meal.id = UUID()
        meal.name = foodName
        meal.calories = Double(calories)
        meal.date = Date()
        meal.imageData = imageData

        saveContext()
    }

    // MARK: - Fetch All Meals
    /// Returns all saved meals sorted by date (newest first)
    func getMeals() -> [MealEntity] {
        let request: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching meals: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Delete Meal
    /// Deletes a specific meal entry.
    func deleteMeal(_ meal: MealEntity) {
        context.delete(meal)
        saveContext()
    }
}
