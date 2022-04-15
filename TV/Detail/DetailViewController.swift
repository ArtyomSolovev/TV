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
    func updateVideo(quality: String)
    var getQuality: ((String) -> Void)? {get set}
}

final class DetailViewController: UIViewController {
    
    private var viewDetail: DetailView?
    private let presenter: DetailPresenter
    private var player = AVPlayer()
    private var playerLaayer: AVPlayerLayer!
    var getQuality: ((String) -> Void)?
    
    init(){
        self.viewDetail = DetailView(frame: UIScreen.main.bounds)
        self.presenter = DetailPresenter()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        if let customView = viewDetail {
            self.view = customView
        }
        self.presenter.loadView(controller: self, view: self.viewDetail!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPlayer()
        self.viewDetail?.configView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.viewDetail?.upadateData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLaayer.frame = self.viewDetail?.videoView.bounds ?? CGRect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.pause()
    }
    
    private func configurePlayer(urlInString: String){
        guard let url = URL(string: urlInString) else {
            print("url failed", urlInString)
            return}
        print("url:", urlInString)
        self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        self.player.play()
    }
    
    private func createPlayer(){
        self.playerLaayer = AVPlayerLayer(player: self.player)
        self.playerLaayer.videoGravity = .resizeAspect
        self.viewDetail?.videoView.layer.addSublayer(self.playerLaayer)
    }
}

extension DetailViewController: IDetailViewController{
    
    func updateVideo(quality: String) {
        self.configurePlayer(urlInString: quality)
    }
    
    func setSelectedChannel(channel: Channel) {
        self.presenter.setSelectedChannel(channel: channel)
    }
}
