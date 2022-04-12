//
//  DetailPresenter.swift
//  TV
//
//  Created by Артем Соловьев on 11.04.2022.
//

protocol IDetailPresenter{
    func loadView(controller: DetailViewController, view: IDetailView)
    func setSelectedChannel(channel: Channel)
    var changeQualityController: ((String) -> Void)? {get set}
}

final class DetailPresenter {
    
    private let modelDetail = DetailModel()
    private weak var controllerDetail: DetailViewController?
    private weak var viewDeatail: IDetailView?
    var changeQualityController: ((String) -> Void)?
    
//    init() {
//        controllerDetail?.getQuality(self.model.getData())
//    }
    
    private func setHandlers(){
        viewDeatail?.onTouchedDismiss = {
            self.controllerDetail?.dismiss(animated: true, completion: nil)
            self.controllerDetail?.viewDidLayoutSubviews()
            self.viewDeatail?.layoutIfNeeded()
        }
        viewDeatail?.onTouchedSettings = { [weak self] vc in
            self?.controllerDetail?.present(vc, animated: true)
        }
        viewDeatail?.changeQuality = { [weak self] quality in
            self?.changeQualityController?(quality)
        }
        controllerDetail?.updateVideo(quality: modelDetail.getData().url)
    }
}

extension DetailPresenter: IDetailPresenter {
    func setSelectedChannel(channel: Channel) {
        self.modelDetail.setSelectedChannel(channel: channel)
    }
    
    func loadView(controller: DetailViewController, view: IDetailView) {
        self.controllerDetail = controller
        self.viewDeatail = view
        self.viewDeatail?.setPresenter(presenter: self, model: modelDetail, channel: modelDetail.getData())
        self.setHandlers()
    }
}
