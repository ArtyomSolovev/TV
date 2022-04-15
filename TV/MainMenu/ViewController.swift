//
//  ViewController.swift
//  TV
//
//  Created by Артем Соловьев on 07.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let viewChoose: IView
    private let presenter: Presenter
    
    init(presenter: IPresenter){
        self.viewChoose = View(frame:UIScreen.main.bounds)
        self.presenter = presenter as! Presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.presenter.loadView(controller: self, view: self.viewChoose)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewChoose.frame = self.view.bounds 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.addSubview(self.viewChoose)
    }

}
