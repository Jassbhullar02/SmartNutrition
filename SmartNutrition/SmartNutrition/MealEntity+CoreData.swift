//
//  MealEntity+CoreData.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import CoreData
import UIKit

@objc(MealEntity)
public class MealEntity: NSManagedObject { }

extension MealEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealEntity> {
        return NSFetchRequest<MealEntity>(entityName: "MealEntity")
    }

    // Match these property names with the attributes in your .xcdatamodeld
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?          // <-- use "name" attribute in model
    @NSManaged public var calories: Double
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var date: Date?
    @NSManaged public var imageData: Data?

    // Convenience computed properties
    public var wrappedName: String {
        name ?? "Unknown"
    }

    public var uiImage: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}
