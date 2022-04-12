//
//  DetailModel.swift
//  TV
//
//  Created by Артем Соловьев on 11.04.2022.
//

import Foundation

protocol IDetailModel {
    func setSelectedChannel(channel: Channel)
    func getData() -> Channel
}

final class DetailModel{
    private var channel: Channel?
}

extension DetailModel: IDetailModel {
    func setSelectedChannel(channel: Channel) {
        self.channel = channel
    }
    
    func getData() -> Channel{
        return channel!
    }
    
}
