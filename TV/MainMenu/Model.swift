//
//  Model.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import Foundation

protocol IModel {
    func getData() -> [Channel]
    func setData(data: [Channel])
}

final class Model: Decodable {
    private var arrayOfChannels = [Channel]()
}

extension Model: IModel {
    
    func getData() -> [Channel]{
        return arrayOfChannels
    }
    
    func setData(data: [Channel]){
         arrayOfChannels = data
    }
    
}


