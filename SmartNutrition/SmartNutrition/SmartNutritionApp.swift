//
//  SmartNutritionApp.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import SwiftUI

@main
struct SmartNutritionApp: App {
    
    // Shared Core Data stack (PersistenceService) is used across the app.
    let persistence = PersistenceService.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
