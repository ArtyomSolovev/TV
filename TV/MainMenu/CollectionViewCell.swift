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
    
    static let id = "CollectionViewCell"
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
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
        dataProvider.downloadImage(url: url) { image in
            self.imageView.image = image
        }
        self.nameLabel.text = channel.nameRu
        self.broadcastLabel.text = channel.current?.title
        self.idOfChannel = channel.id
        self.backgroundColor = UIColor(hex: "#373740")
    }
    
    func setFavoritesIcon(change: Bool) {
        self.imageIcon.imageView?.tintColor = change ?  UIColor(hex: "#115CFF") : UIColor(hex: "#939699")
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
        setupPhoto()
        setupImageIcon()
        setupName()
        setupPlace()
    }
    
    private func setupPhoto() {
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupImageIcon(){
        imageIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        imageIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupName(){
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: imageIcon.leftAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
    }
    
    private func setupPlace(){
        broadcastLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16).isActive = true
        broadcastLabel.rightAnchor.constraint(equalTo: imageIcon.leftAnchor).isActive = true
        broadcastLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func configureLayer() {
        layer.cornerRadius = 10
    }
    
}
