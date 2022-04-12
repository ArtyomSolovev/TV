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
        loadData()
    }
    
    private func setHandlers(){
        view?.getNumberOfRowsHandler = { [weak self] type in
            (self?.model.getData(typeOfData: type).count) ?? 0
        }
        view?.getContentForCellHandler = { [weak self] (type, index) in
            (self?.model.getData(typeOfData: type)[index])!
        }
        view?.onTouchedHandler = { [weak self] (type, index) in
            self?.router.pushDetailVC(with: (self?.model.getData(typeOfData: type)[index])!)
        }
        view?.getNumberOfFavorites = { [weak self] in
            self?.model.getFavoritesCountChannels() ?? 0
        }
        view?.addToFavorites = { [weak self] id in
            self?.model.changeStateOfFavorites(channelId: id) ?? false
        }
        view?.isItFavorite = { [weak self] id in
            self?.model.contains(channelId: id) ?? false
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
