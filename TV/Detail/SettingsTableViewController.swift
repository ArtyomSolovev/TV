//
//  SettingsTableViewController.swift
//  TV
//
//  Created by Артем Соловьев on 11.04.2022.
//

import UIKit

final class SettingsTableViewController: UITableViewController {
    
    private let quality = [Constants.WorkWithURL.lowQuality.numbers, Constants.WorkWithURL.middleQuality.numbers, Constants.WorkWithURL.highQuality.numbers]
    
    weak var settingsDelegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isScrollEnabled = false
        self.view.backgroundColor = UIColor(hex: Constants.SystemColor.grey)
    }

    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: self.tableView.contentSize.height)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.quality.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.textLabel?.text = self.quality[indexPath.row]
        cell.backgroundColor = UIColor(hex: Constants.SystemColor.grey)
        cell.textLabel?.textColor = .white

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.settingsDelegate?.update(settingsButton: self.quality[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
    }
}
