//
//  Model.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import Foundation

protocol IModel {
    func getData(typeOfData:Int) -> [Channel]
    func setData(data: [Channel])
    func getFavoritesCountChannels() -> Int
    func contains(channelId: Int) -> Bool
    func changeStateOfFavorites(channelId: Int) -> Bool
}

final class Model {
    private var arrayOfChannels = [Channel]()
    private var arrayOfFavorites = [Channel]()
    private var arrayOfIdFavorites = [Int]()
    
    init() {
        self.arrayOfIdFavorites = Favorites.instance.loadFavorites()
    }
}

extension Model: IModel {
    func getData(typeOfData:Int) -> [Channel]{
        if typeOfData == 0 {
            return self.arrayOfChannels
        } else {
            return self.arrayOfFavorites
        }
    }
    
    func setData(data: [Channel]){
        self.arrayOfChannels = data
        self.arrayOfChannels.forEach { channel in
            if self.arrayOfIdFavorites.contains(channel.id){
                self.arrayOfFavorites.append(channel)
            }
        }
    }
    
    // MARK: - Favorites
    
    func changeStateOfFavorites(channelId: Int) -> Bool {
        if self.arrayOfIdFavorites.contains(channelId) {
            if let index = self.arrayOfIdFavorites.firstIndex(of: channelId) {
                self.arrayOfIdFavorites.remove(at: index)
                self.arrayOfFavorites.remove(at: index)
            }
            Favorites.instance.saveFavorites(array: self.arrayOfIdFavorites)
            return false
        } else {
            self.arrayOfIdFavorites.append(channelId)
            self.arrayOfChannels.forEach { channel in
                if channelId == channel.id{
                    self.arrayOfFavorites.append(channel)
                }
            }
            Favorites.instance.saveFavorites(array: self.arrayOfIdFavorites)
            return true
        }
    }
    
    func getFavoritesCountChannels() -> Int {
        self.arrayOfIdFavorites = Favorites.instance.loadFavorites()
        return self.arrayOfIdFavorites.count
    }
    
    func contains(channelId: Int) -> Bool {
        self.arrayOfIdFavorites.contains(channelId)
    }
}
