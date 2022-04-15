//
//  View.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import UIKit

protocol IView: UIView {
    var getNumberOfRowsHandler: ((Int) -> [Channel])? { get set }
    var getContentForCellHandler: ((Int, Int) -> Channel)? { get set }
    var onTouchedHandler: ((Int, Int) -> Void)? { get set }
    var reloudData: (()->()){get}
    var getNumberOfFavorites: (() -> Int)? { get set }
    var addToFavorites: ((Int) -> Bool)? { get set }
    var isItFavorite: ((Int) -> Bool)? { get set }
    var pushFilterChannel: ((Channel) -> Void)? { get set }
}

final class View: UIView {
    
    private var presenter: Presenter?
    private var favorites = [Int]()
    var getNumberOfRowsHandler: ((Int) -> [Channel])?
    var getContentForCellHandler: ((Int, Int) -> Channel)?
    var onTouchedHandler: ((Int, Int) -> Void)?
    var getNumberOfFavorites: (() -> Int)?
    var addToFavorites: ((Int) -> Bool)?
    var isItFavorite: ((Int) -> Bool)?
    var pushFilterChannel: ((Channel) -> Void)?
    
    private var filteredData: [Channel]?
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFilter: Bool {
        return !searchBarIsEmpty
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = UIColor(hex: Constants.SystemColor.grey)
        searchBar.placeholder = Constants.PlaceHolder.searchBar
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
        view.backgroundColor = UIColor(hex: Constants.SystemColor.darkGrey)
        return view
    }()
    
    private let segmentedControl: CustomSegmentedControl = {
        let rect = CustomSegmentedControl(frame: CGRect(), buttonTitle: [Constants.PlaceHolder.Button.all, Constants.PlaceHolder.Button.favorites])
        rect.backgroundColor = UIColor(hex: Constants.SystemColor.grey)
        rect.translatesAutoresizingMaskIntoConstraints = false
        return rect
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.backgroundColor = UIColor(hex: Constants.SystemColor.grey)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topPadding).isActive = true
        self.searchBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.searchBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    fileprivate func setUpSegmentedControl() {
        self.segmentedControl.delegate = self
        self.segmentedControl.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07).isActive = true
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
        self.setUpSearchBar()
        self.setUpSegmentedControl()
        self.setUpCollectionView()
    }
}

extension View: IView {
    var reloudData: (() -> ()) {
        self.collectionView.reloadData
    }
}

extension View: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFilter {
            self.pushFilterChannel?((self.filteredData?[indexPath.item])!)
        } else {
            self.onTouchedHandler?(self.segmentedControl.selectedIndex, indexPath.item)
        }
    }
}

extension View: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isFilter {
            return self.filteredData?.count ?? 0
        } else {
            return self.getNumberOfRowsHandler?(segmentedControl.selectedIndex).count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath) as! CollectionViewCell
        if self.isFilter {
            if let channel = self.filteredData?[indexPath.row] {
                cell.delegate = self
                cell.setChannel(channel: channel)
                let favorite = self.isItFavorite?(channel.id) ?? false
                cell.setFavoritesIcon(change: favorite)
            }
        } else {
            if let channel = self.getContentForCellHandler?(segmentedControl.selectedIndex, indexPath.row) {
                cell.delegate = self
                cell.setChannel(channel: channel)
                let favorite = self.isItFavorite?(channel.id) ?? false
                cell.setFavoritesIcon(change: favorite)
            }
        }
            return cell
    }
}

extension View: CollectionViewCellDelegate{
    func didTapButton(row: Int) -> Bool{
        let result = self.addToFavorites?(row) ?? false
        self.collectionView.reloadData()
        return result
    }
}

extension View: CustomSegmentedControlDelegate{
    func change(to index: Int) {
        self.collectionView.reloadData()
    }
}

extension View: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let data = self.getNumberOfRowsHandler?(segmentedControl.selectedIndex)
        filteredData = searchText.isEmpty ? data : data?.filter { (item: Channel) -> Bool in
            return item.nameRu.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.collectionView.reloadData()
    }
}

extension View: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            return true
    }
}
