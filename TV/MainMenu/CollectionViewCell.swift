//
//  CollectionViewCell.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func didTapButton(row: Int) -> Bool
}

final class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    private var dataProvider = DataProvider()
    
    static let id = Constants.ID.cellId
    private var idOfChannel: Int?

    private var imageView : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var imageIcon : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.NameImage.starIcon), for: .normal)
        button.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func addToFavorites(sender: UIButton!) {
        setFavoritesIcon(change: delegate?.didTapButton(row: idOfChannel ?? 0) ?? false)
    }
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 18)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let broadcastLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setChannel(channel: Channel){
        guard let url = URL(string: channel.image) else {return}
        self.dataProvider.downloadImage(url: url) { image in
            self.imageView.image = image
        }
        self.nameLabel.text = channel.nameRu
        self.broadcastLabel.text = channel.current?.title
        self.idOfChannel = channel.id
        if channel.url != "" {
            print(channel.nameRu, "", channel.url)
        } else {
            print(channel.nameRu, "Fail")
        }
        self.backgroundColor = UIColor(hex: Constants.SystemColor.grey)
    }
    
    func setFavoritesIcon(change: Bool) {
        self.imageIcon.imageView?.tintColor = change ?  UIColor(hex: Constants
            .SystemColor.blue) : UIColor(hex: Constants.SystemColor.lightGrey)
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.alpha = self.isHighlighted ? 0.5 : 1.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureContentLayout()
        self.configureLayer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContentLayout() {
        self.addSubview(imageView)
        self.addSubview(imageIcon)
        self.addSubview(nameLabel)
        self.addSubview(broadcastLabel)
        self.setupPhoto()
        self.setupImageIcon()
        self.setupName()
        self.setupPlace()
    }
    
    private func setupPhoto() {
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupImageIcon(){
        self.imageIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        self.imageIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        self.imageIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.imageIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupName(){
        self.nameLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.imageIcon.leftAnchor).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
    }
    
    private func setupPlace(){
        self.broadcastLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16).isActive = true
        self.broadcastLabel.rightAnchor.constraint(equalTo: self.imageIcon.leftAnchor).isActive = true
        self.broadcastLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func configureLayer() {
        self.layer.cornerRadius = 10
    }
    
}
