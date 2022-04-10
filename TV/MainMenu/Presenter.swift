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
        view?.getNumberOfRowsHandler = { [weak self] in
            (self?.model.getData().count) ?? 0
        }
        view?.getContentForCellHandler = { [weak self] index in
            (self?.model.getData()[index])!
        }
        view?.onTouchedHandler = { [weak self] index in
            self?.router.pushDetailVC(with: index)
        }
    }
    
    func loadData() {
        self.networkService.loadData { (result: Result<Welcome, Error>) in
            switch result {
            case .success(let model):
                print("[NETWORK] model is: \(model)")
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
