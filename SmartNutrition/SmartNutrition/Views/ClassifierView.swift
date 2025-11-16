//
//  ClassifierView.swift
//  SmartNutrition
//
//  Created by Jaspreet Bhullar on 15/11/25.
//

import SwiftUI
import UIKit

struct ClassifierView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = FoodClassifierViewModel()

    // Image picker required states
    @State private var showImagePicker = false
    @State private var pickedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var onComplete: (() -> Void)?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // Selected image preview
                if let image = pickedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 240)
                        .cornerRadius(12)
                } else {
                    Rectangle()
                        .fill(.secondary.opacity(0.1))
                        .frame(height: 240)
                        .overlay(Text("No image selected").foregroundStyle(.secondary))
                        .cornerRadius(12)
                }

                // Buttons
                HStack(spacing: 12) {
                    Button("Pick Photo") {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }

                    Button("Use Camera") {
                        sourceType = .camera
                        showImagePicker = true
                    }

                    Button("Classify") {
                        guard let image = pickedImage else { return }
                        vm.classify(image: image)
                    }
                    .disabled(pickedImage == nil)
                }

                // Loading
                if vm.isLoading {
                    ProgressView("Classifying...")
                }

                // Error
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                // Results
                List {
                    // Predictions
                    if !vm.predictions.isEmpty {
                        Section("Predictions") {
                            ForEach(Array(vm.predictions.enumerated()), id: \.offset) { (_, pred) in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(pred.0).bold()
                                        Text("Confidence: \(Int(pred.1 * 100))%")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Button("Use") {
                                        Task {
                                            let nutrition = try? await NutritionAPIService.shared.fetchNutrition(for: pred.0)
                                            if let nutrition = nutrition {
                                                vm.selectedFood = nutrition
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Nutrition details
                    if let selected = vm.selectedFood {
                        Section("Nutrition") {
                            NavigationLink(
                                destination: NutritionDetailView(
                                    food: selected,
                                    originalImage: pickedImage
                                ) {
                                    vm.saveSelectedFood(with: pickedImage)
                                    onComplete?()
                                    dismiss()
                                }
                            ) {
                                VStack(alignment: .leading) {
                                    Text(selected.name).bold()
                                    Text("\(selected.calories) kcal | P: \(selected.protein)g | C: \(selected.carbs)g | F: \(selected.fat)g")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Classify Food")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                }
            }

            // Image Picker Sheet (UPDATED)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $pickedImage, sourceType: sourceType)
            }

            .onChange(of: pickedImage) { _ in
                vm.predictions = []
                vm.selectedFood = nil
            }
        }
    }
}

#Preview {
    ClassifierView()
}
