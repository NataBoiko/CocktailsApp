//
//  FiltersRequest.swift
//  CocktailsApp
//
//  Created by Nata Boiko on 16.07.2020.
//  Copyright © 2020 Nata Boiko. All rights reserved.
//

import Foundation


enum FiltersError: Error {
    case noDataAvailible
    case canNotProcessData
}

struct FiltersRequest {
    
    let resourceURL: URL
    let api_key = "1"
    
    init() {
        let resourceString = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        self.resourceURL = resourceURL
    }
    
    func getFilters(completion: @escaping(Result<[Category], FiltersError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailible))
                return
            }
            do {
                let decoder = JSONDecoder()
                let cocktailsResponse = try decoder.decode(Filters.self, from: jsonData)
                let cocktails = cocktailsResponse.drinks
                completion(.success(cocktails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
