//
//  Favorites.swift
//  TV
//
//  Created by Артем Соловьев on 12.04.2022.
//

import Foundation

final class Favorites {

    static let instance = Favorites()
    private var favorites = [Int]()
    private let favoritesKey = "favoritesKey"
    
    func saveFavorites(array: [Int]) {
        favorites = array
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func loadFavorites() -> [Int] {
        guard let downloudData = UserDefaults.standard.array(forKey: favoritesKey) else { return [] }
        favorites = downloudData as? [Int] ?? [Int]()
        return favorites
    }
}
