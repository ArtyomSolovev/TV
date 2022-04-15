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
        viewDeatail?.onTouchedDismiss = {
            self.controllerDetail?.dismiss(animated: true, completion: nil)
//            self.controllerDetail?.viewDidLayoutSubviews()//?
//            self.viewDeatail?.layoutIfNeeded()//?
        }
        viewDeatail?.onTouchedSettings = { [weak self] vc in
            self?.controllerDetail?.present(vc, animated: true)
        }
        viewDeatail?.changeQuality = { [weak self] quality in
            var fullUrlQuality: String
            switch quality {
            case "360":
                fullUrlQuality = (self?.modelDetail.getData().url)!.replacingOccurrences(of: "index.m3u8", with: "tracks-v1a1/mono.m3u8")
            case "480":
                fullUrlQuality = (self?.modelDetail.getData().url)!.replacingOccurrences(of: "index.m3u8", with: "tracks-v2a1/mono.m3u8")
            case "720":
                fullUrlQuality = (self?.modelDetail.getData().url)!.replacingOccurrences(of: "index.m3u8", with: "tracks-v3a1/mono.m3u8")
            default:
                fullUrlQuality = (self?.modelDetail.getData().url)!
            }
            self?.controllerDetail?.updateVideo(quality: fullUrlQuality)
        }
        controllerDetail?.updateVideo(quality: self.modelDetail.getData().url)
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
