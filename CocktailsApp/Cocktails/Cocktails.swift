//
//  Cocktails.swift
//  CocktailsApp
//
//  Created by Nata Boiko on 16.07.2020.
//  Copyright © 2020 Nata Boiko. All rights reserved.
//


import Foundation

// MARK: - Cocktails
struct Cocktails: Codable {
    var drinks: [Drink]
}

// MARK: - Drink
struct Drink: Codable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}

