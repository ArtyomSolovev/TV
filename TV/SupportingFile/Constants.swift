//
//  Constants.swift
//  TV
//
//  Created by Артем Соловьев on 15.04.2022.
//

import UIKit

enum Constants {
    
    static let topPadding = UIApplication.shared.windows.first!.safeAreaInsets.top
    static let URL = "https://limehd.online/playlist/"
    static let favoritesKey = "favoritesKey"
    
    enum WorkWithURL {
        static let standart = "index.m3u8"
        enum lowQuality {
            static let numbers = "360"
            static let urlEnd = "tracks-v1a1/mono.m3u8"
        }
        enum middleQuality {
            static let numbers = "480"
            static let urlEnd = "tracks-v2a1/mono.m3u8"
        }
        enum highQuality {
            static let numbers = "720"
            static let urlEnd = "tracks-v3a1/mono.m3u8"
        }
    }
    
    enum ID {
        static let cellId = "CollectionViewCell"
    }
    
    enum SystemColor {
        static let grey = "#373740"
        static let greyForSegmetVC = "#828282"
        static let darkGrey = "#373740"
        static let blue = "#115CFF"
        static let lightGrey = "#939699"
        static let white = "#F0F0F0"
    }
    
    enum PlaceHolder {
        static let searchBar = " Напишите название телеканала"
        enum Button {
            static let all = "Все"
            static let favorites = "Избранные"
        }
    }
    
    enum NameImage {
        static let buttonBack = "arrow.backward"
        static let buttonSettings = "gearshape"
        static let starIcon = "star.fill"
    }
}
