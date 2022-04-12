//
//  DetailPresenter.swift
//  TV
//
//  Created by Артем Соловьев on 11.04.2022.
//

protocol IDetailPresenter{
    func loadView(controller: DetailViewController, view: IDetailView)
    func setSelectedChannel(channel: Channel)
}

final class DetailPresenter {
    
    private let model = DetailModel()
    private weak var controllerDetail: DetailViewController?
    private weak var viewDeatail: IDetailView?
    
    private func setHandlers(){
        viewDeatail?.onTouchedDismiss = {
            self.controllerDetail?.dismiss(animated: true, completion: nil)
            self.controllerDetail?.viewDidLayoutSubviews()
            self.viewDeatail?.layoutIfNeeded()
        }
        viewDeatail?.onTouchedSettings = { [weak self] vc in
            self?.controllerDetail?.present(vc, animated: true)
        }
    }
}

extension DetailPresenter: IDetailPresenter {
    func setSelectedChannel(channel: Channel) {
        self.model.setSelectedChannel(channel: channel)
    }
    
    func loadView(controller: DetailViewController, view: IDetailView) {
        self.controllerDetail = controller
        self.viewDeatail = view
        self.viewDeatail?.setPresenter(presenter: self, model: model, channel: model.getData())
        self.setHandlers()
    }
}
