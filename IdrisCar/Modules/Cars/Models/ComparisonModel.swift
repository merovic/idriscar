//
//  ComparisonModel.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 29/05/2025.
//

struct CarComparisonModel {
    let car1: Car
    let car2: Car?
    let featureGroups: [FeatureComparison]
}

struct FeatureComparison {
    let groupName: String
    let features: [FeatureItemComparison]
}

struct FeatureItemComparison {
    let name: String
    let car1Value: String?
    let car2Value: String?
}
