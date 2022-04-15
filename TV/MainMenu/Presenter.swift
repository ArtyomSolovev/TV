//
//  Presenter.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import Foundation

protocol IPresenter{
    func loadView(controller: ViewController, view: IView)
}

final class Presenter {
    private let model: IModel
    private let router: IRouter
    private weak var controller: ViewController?
    private weak var view: IView?
    private let networkService: INetworkService = NetworkService()
    
    init(model: IModel, router: IRouter) {
        self.model = model
        self.router = router as! Router
        self.loadData()
    }
    
    private func setHandlers(){
        self.view?.getNumberOfRowsHandler = { [weak self] type in
            self?.model.getData(typeOfData: type) ?? [Channel]()
        }
        self.view?.getContentForCellHandler = { [weak self] (type, index) in
            (self?.model.getData(typeOfData: type)[index])!
        }
        self.view?.onTouchedHandler = { [weak self] (type, index) in
            self?.router.pushDetailVC(with: (self?.model.getData(typeOfData: type)[index])!)
        }
        self.view?.getNumberOfFavorites = { [weak self] in
            self?.model.getFavoritesCountChannels() ?? 0
        }
        self.view?.addToFavorites = { [weak self] id in
            self?.model.changeStateOfFavorites(channelId: id) ?? false
        }
        self.view?.isItFavorite = { [weak self] id in
            self?.model.contains(channelId: id) ?? false
        }
        self.view?.pushFilterChannel = { [weak self] channel in
            self?.router.pushDetailVC(with: channel)
        }
    }
    
    func loadData() {
        self.networkService.loadData { (result: Result<Welcome, Error>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.model.setData(data: model.channels)
                    self.view?.reloudData()
                }
            case .failure(let error):
                print("[NETWORK] error is: \(error)")
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension Presenter: IPresenter {
    func loadView(controller: ViewController, view: IView) {
        self.controller = controller
        self.view = view
        self.setHandlers()
    }
}
