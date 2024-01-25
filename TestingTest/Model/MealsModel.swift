//
//  SearchModel.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation

struct MealsModel: Codable {
    var meals: [MealModel]?
}

struct MealModel: Codable {
    var idMeal: String?
    var strMeal: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String?
    var strMealThumb: String?
    var strTags: String?
}

struct IndigrientsModel {
    var indigrience: String
}

