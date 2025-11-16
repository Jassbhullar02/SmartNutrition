//
//  MLClassifierService.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

//import Foundation
//import UIKit
//
//final class MLClassifierService {
//    static let shared = MLClassifierService()
//    private init() {}
//
//    /// Temporary simulate classification. Returns top 3 dummy predictions with confidence.
//    func classify(image: UIImage) async throws -> [(label: String, confidence: Double)] {
//        // Simulated network / processing delay
//        try await Task.sleep(nanoseconds: 300_000_000)
//        return [
//            (label: "Apple", confidence: 0.78),
//            (label: "Banana", confidence: 0.12),
//            (label: "Sandwich", confidence: 0.05)
//        ]
//    }
//}

import Foundation
import UIKit
import CoreML
import Vision

final class MLClassifierService {
    static let shared = MLClassifierService()
    private init() {}

    /// Classify image using your trained Core ML model
    func classify(image: UIImage) async throws -> [(label: String, confidence: Double)] {

        guard let ciImage = CIImage(image: image) else {
            throw NSError(domain: "InvalidImage", code: -1)
        }

        // Load CoreML model
        let config = MLModelConfiguration()
        let model = try VNCoreMLModel(for: Food5(configuration: config).model)

        // Request for classification
        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(ciImage: ciImage)

        try handler.perform([request])

        guard let results = request.results as? [VNClassificationObservation] else {
            throw NSError(domain: "NoResults", code: -2)
        }

        // Take Top-3 predictions
        let top3 = results.prefix(3).map { result in
            (label: result.identifier,
             confidence: Double(result.confidence))
        }

        return top3
    }
}
