//
//  DetailView.swift
//  TV
//
//  Created by Артем Соловьев on 11.04.2022.
//

import UIKit
import AVFoundation

protocol IDetailView: UIView {
    var onTouchedDismiss: (() -> Void)? { get set }
    func upadateData()
    func setPresenter(presenter: DetailPresenter, model: DetailModel, channel: Channel)
    var onTouchedSettings: ((SettingsTableViewController) -> Void)? { get set }
    var changeQuality: ((String)->Void)? {get set}
}

protocol SettingsDelegate: AnyObject {
    func update(settingsButton: String)
}

final class DetailView: UIView, UIPopoverPresentationControllerDelegate {
    
    private var presenter: DetailPresenter?
    private var model: DetailModel?
    private let tableSettings = SettingsTableViewController()
    
    var onTouchedDismiss: (() -> Void)?
    var onTouchedSettings: ((SettingsTableViewController) -> Void)?
    var changeQuality: ((String)->Void)?
    
    let videoView: UIView = {
        let videoView = UIView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.backgroundColor = UIColor(hex: Constants.SystemColor.grey)
        return videoView
    }()
    
    private var mainTitleView : UIView = {
        let mainTitleView = UIView()
        mainTitleView.translatesAutoresizingMaskIntoConstraints = false
        return mainTitleView
    }()
    
    private let buttonBack: UIButton = {
        let buttonBack = UIButton()
        buttonBack.setImage(UIImage(systemName: Constants.NameImage.buttonBack), for: .normal)
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.tintColor = .white
        buttonBack.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return buttonBack
    }()

    @objc private func buttonAction(sender: UIButton!) {
        self.onTouchedDismiss?()
    }
    
    private var imageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        return image
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .gray
        return name
    }()
    
    private var buttonSettings : UIButton = {
        let buttonSettings = UIButton()
        buttonSettings.setImage(UIImage(systemName: Constants.NameImage.buttonSettings ), for: .normal)
        buttonSettings.tintColor = .white
        buttonSettings.translatesAutoresizingMaskIntoConstraints = false
        buttonSettings.addTarget(self, action: #selector(buttonSettingsAction), for: .touchUpInside)
        return buttonSettings
    }()
    
    @objc private func buttonSettingsAction(sender: UIButton) {
        tableSettings.settingsDelegate = self
        if let sheet = tableSettings.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.onTouchedSettings?(tableSettings)
    }
    
    func configView() {
        self.backgroundColor = .tintColor
        self.setUpVideoView()
        self.configureStackView()
        self.setButtonSettings()
        self.upadateData()
    }
        
    fileprivate func setUpVideoView() {
        self.addSubview(self.videoView)
        self.videoView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.videoView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.videoView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    fileprivate func setButtonSettings() {
        self.addSubview(self.buttonSettings)
        self.buttonSettings.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        self.buttonSettings.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -44).isActive = true
    }
    
    private func configureStackView(){
        
        self.addSubview(mainTitleView)
        self.mainTitleView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topPadding).isActive = true
        self.mainTitleView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.mainTitleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.mainTitleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.addArrangedSubview(self.titleLabel)
        view.addArrangedSubview(self.nameLabel)
        
        self.mainTitleView.addSubview(self.buttonBack)
        self.buttonBack.topAnchor.constraint(equalTo: self.mainTitleView.topAnchor).isActive = true
        self.buttonBack.leftAnchor.constraint(equalTo: self.mainTitleView.leftAnchor).isActive = true
        self.buttonBack.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.buttonBack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.mainTitleView.addSubview(self.imageView)
        self.imageView.leftAnchor.constraint(equalTo: self.buttonBack.rightAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.mainTitleView.topAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.mainTitleView.addSubview(view)
        view.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 24).isActive = true
        view.rightAnchor.constraint(equalTo: self.mainTitleView.rightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}

extension DetailView: IDetailView{
    func upadateData() {
        self.titleLabel.text = model?.getData().current?.title
        self.nameLabel.text = model?.getData().nameRu
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: (self?.model?.getData().image)!) else {return}
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    func setPresenter(presenter: DetailPresenter, model: DetailModel, channel: Channel) {
        self.presenter = presenter
        self.model = model
        self.model?.setSelectedChannel(channel: channel)
    }
}

extension DetailView: SettingsDelegate{
    func update(settingsButton: String) {
        self.changeQuality?(settingsButton)
    }
}
