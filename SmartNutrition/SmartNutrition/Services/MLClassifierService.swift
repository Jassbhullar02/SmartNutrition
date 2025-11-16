//
//  MLClassifierService.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import Foundation
import UIKit

final class MLClassifierService {
    static let shared = MLClassifierService()
    private init() {}

    /// Temporary simulate classification. Returns top 3 dummy predictions with confidence.
    func classify(image: UIImage) async throws -> [(label: String, confidence: Double)] {
        // Simulated network / processing delay
        try await Task.sleep(nanoseconds: 300_000_000)
        return [
            (label: "Apple", confidence: 0.78),
            (label: "Banana", confidence: 0.12),
            (label: "Sandwich", confidence: 0.05)
        ]
    }
}
