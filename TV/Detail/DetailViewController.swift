//
//  DetailViewController.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    init(model: IModel){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
