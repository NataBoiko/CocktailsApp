//
//  Filters.swift
//  CocktailsApp
//
//  Created by Nata Boiko on 16.07.2020.
//  Copyright © 2020 Nata Boiko. All rights reserved.
//

import Foundation


// MARK: - Filters
struct Filters: Codable {
    let drinks: [Category]
}

// MARK: - Drink
struct Category: Codable {
    let strCategory: String
}
