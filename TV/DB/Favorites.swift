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
    
    func saveFavorites(array: [Int]) {
        self.favorites = array
        UserDefaults.standard.set(self.favorites, forKey: Constants.favoritesKey)
    }
    
    func loadFavorites() -> [Int] {
        guard let downloudData = UserDefaults.standard.array(forKey: Constants.favoritesKey) else { return [] }
        self.favorites = downloudData as? [Int] ?? [Int]()
        return favorites
    }
}
