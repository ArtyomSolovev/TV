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
    
    private let modelDetail = DetailModel()
    private weak var controllerDetail: DetailViewController?
    private weak var viewDeatail: IDetailView?
    
    private func setHandlers(){
        self.viewDeatail?.onTouchedDismiss = {
            self.controllerDetail?.dismiss(animated: true, completion: nil)
        }
        self.viewDeatail?.onTouchedSettings = { [weak self] vc in
            self?.controllerDetail?.present(vc, animated: true)
        }
        self.viewDeatail?.changeQuality = { [weak self] quality in
            var fullUrlQuality: String
            switch quality {
            case Constants.WorkWithURL.lowQuality.numbers:
                fullUrlQuality = (self?.modelDetail.getData().url)!.replacingOccurrences(of: Constants.WorkWithURL.standart, with: Constants.WorkWithURL.lowQuality.urlEnd)
            case Constants.WorkWithURL.middleQuality.numbers:
                fullUrlQuality = (self?.modelDetail.getData().url)!.replacingOccurrences(of: Constants.WorkWithURL.standart, with: Constants.WorkWithURL.middleQuality.urlEnd)
            case Constants.WorkWithURL.highQuality.numbers:
                fullUrlQuality = (self?.modelDetail.getData().url)!.replacingOccurrences(of: Constants.WorkWithURL.standart, with: Constants.WorkWithURL.highQuality.urlEnd)
            default:
                fullUrlQuality = (self?.modelDetail.getData().url)!
            }
            self?.controllerDetail?.updateVideo(quality: fullUrlQuality)
        }
        self.controllerDetail?.updateVideo(quality: self.modelDetail.getData().url)
    }
}

extension DetailPresenter: IDetailPresenter {
    func setSelectedChannel(channel: Channel) {
        self.modelDetail.setSelectedChannel(channel: channel)
        self.controllerDetail?.updateVideo(quality: channel.url)
    }
    
    func loadView(controller: DetailViewController, view: IDetailView) {
        self.controllerDetail = controller
        self.viewDeatail = view
        self.viewDeatail?.setPresenter(presenter: self, model: modelDetail, channel: modelDetail.getData())
        self.setHandlers()
    }
}
