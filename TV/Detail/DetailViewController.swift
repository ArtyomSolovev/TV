//
//  DetailViewController.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import UIKit
import AVFoundation

protocol IDetailViewController: UIViewController {
    func setSelectedChannel(channel: Channel)
}

final class DetailViewController: UIViewController {
    
    private var viewDetail: DetailView?
    private let presenter: DetailPresenter
    private var player: AVPlayer!
    private var playerLaayer: AVPlayerLayer!
    
    init(){
        self.viewDetail = DetailView(frame: UIScreen.main.bounds)
        self.presenter = DetailPresenter()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
        viewDetail?.configView()
    }
    
    override func loadView() {
        super.loadView()
        if let customView = viewDetail {
            self.view = customView
        }
        self.presenter.loadView(controller: self, view: self.viewDetail!)
    }

    override func viewDidAppear(_ animated: Bool) {
        player.play()
        viewDetail?.upadateData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLaayer.frame = self.viewDetail?.videoView.bounds ?? CGRect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    private func configurePlayer(){
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/app_store/app-store-product-page/hls_vod_mvp.m3u8") else {return}//model.getData()[indexChannel ?? 0].url
        player = AVPlayer(url: url)
        
        playerLaayer = AVPlayerLayer(player: player)
        playerLaayer.videoGravity = .resizeAspect
        
        viewDetail?.videoView.layer.addSublayer(playerLaayer)
    }
}

extension DetailViewController: IDetailViewController{
    func setSelectedChannel(channel: Channel) {
        self.presenter.setSelectedChannel(channel: channel)
    }
}
