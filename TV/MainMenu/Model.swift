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
//    func addToFavorites(channelId: Int)
//    func deleteFromFavorites(channelId: Int)
    func getFavoritesCountChannels() -> Int
    func contains(channelId: Int) -> Bool
    func changeStateOfFavorites(channelId: Int) -> Bool
}

final class Model {
    private var arrayOfChannels = [Channel]()
    private var arrayOfFavorites = [Channel]()
    private var arrayOfIdFavorites = [Int]()
    
    init() {
        arrayOfIdFavorites = Favorites.instance.loadFavorites()
    }
}

extension Model: IModel {
    func getData(typeOfData:Int) -> [Channel]{
        if typeOfData == 0 {
            return arrayOfChannels
        } else {
            return arrayOfFavorites
        }
    }
    
    func setData(data: [Channel]){
        arrayOfChannels = data
        arrayOfChannels.forEach { channel in
            if arrayOfIdFavorites.contains(channel.id){
                arrayOfFavorites.append(channel)
            }
        }
    }
    
    // MARK: - Favorites
    
    func changeStateOfFavorites(channelId: Int) -> Bool {
        if arrayOfIdFavorites.contains(channelId) {
            if let index = arrayOfIdFavorites.firstIndex(of: channelId) {
                arrayOfIdFavorites.remove(at: index)
                arrayOfFavorites.remove(at: index)
            }
//            arrayOfChannels.forEach { channel in
//                if arrayOfIdFavorites.contains(channel.id){
//                    arrayOfFavorites.remove(at: a)
//                }
//            }
            Favorites.instance.saveFavorites(array: arrayOfIdFavorites)
            return false
        } else {
            arrayOfIdFavorites.append(channelId)
            arrayOfChannels.forEach { channel in
                if channelId == channel.id{
                    arrayOfFavorites.append(channel)
                }
            }
            Favorites.instance.saveFavorites(array: arrayOfIdFavorites)
            return true
        }
    }
    
//    func addToFavorites(channelId: Int) {
//        arrayOfFavorites.append(channelId)
//        Favorites.instance.saveFavorites(array: arrayOfFavorites)
//    }
    
    func getFavoritesCountChannels() -> Int {
        arrayOfIdFavorites = Favorites.instance.loadFavorites()
        return arrayOfIdFavorites.count
    }
    
//    func deleteFromFavorites(channelId: Int) {
//        if let index = arrayOfFavorites.firstIndex(of: channelId) {
//            arrayOfFavorites.remove(at: index)
//        }
//        Favorites.instance.saveFavorites(array: arrayOfFavorites)
//    }
    
    func contains(channelId: Int) -> Bool {
        arrayOfIdFavorites.contains(channelId)
    }
}
