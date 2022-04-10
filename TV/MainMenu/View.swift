//
//  View.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import UIKit

protocol IView: UIView {
    var getNumberOfRowsHandler: (() -> Int)? { get set }
    var getContentForCellHandler: ((Int) -> Channel)? { get set }
    var onTouchedHandler: ((Int) -> Void)? { get set }
    var reloudData: (()->()){get}
}

final class View: UIView {
    
    private var presenter: Presenter?
    var getNumberOfRowsHandler: (() -> Int)?
    var getContentForCellHandler: ((Int) -> Channel)?
    var onTouchedHandler: ((Int) -> Void)?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = UIColor(hex: "#373740")
        searchBar.placeholder = " Напишите название телеканала"
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-30, height: 76)
        let view = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#262729")
        return view
    }()
    
    private let segmentedControl: CustomSegmentedControl = {
        let rect = CustomSegmentedControl(frame: CGRect(), buttonTitle: ["Все", "Избранные"])
        rect.backgroundColor = UIColor(hex: "#373740")
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
//        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpSearchBar() {
        let topPadding = UIApplication.shared.windows.first!.safeAreaInsets.top
        self.searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: topPadding).isActive = true
        self.searchBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.searchBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        self.searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    fileprivate func setUpSegmentedControl() {
        self.segmentedControl.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07).isActive = true
//        self.rect.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    fileprivate func setUpCollectionView() {
        self.collectionView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func configure() {
        self.addSubview(self.searchBar)
        self.addSubview(self.segmentedControl)
        self.addSubview(self.collectionView)
        setUpSearchBar()
        setUpSegmentedControl()
        setUpCollectionView()
    }
}

extension View: IView {
    var reloudData: (() -> ()) {
        self.collectionView.reloadData
    }
}

extension View: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MARK: - to do
    }
    
}

extension View: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // MARK: - вниз?
        collectionView.reloadData()
        return self.getNumberOfRowsHandler?() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath) as! CollectionViewCell
        if let channel = self.getContentForCellHandler?(indexPath.row) {
            cell.setChannel(channel: channel)
        }
        return cell
    }
    
}
