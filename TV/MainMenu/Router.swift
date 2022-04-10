//
//  Router.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import Foundation

protocol IRouter {
    func setRootController(controller: ViewController)
    func setTargerController(controller: DetailViewController)
    func pushDetailVC(with index: Int)
}

final class Router {
    private var controller: ViewController?
    private var targetController: DetailViewController?
}

extension Router: IRouter {
    
    func setRootController(controller: ViewController) {
        self.controller = controller
    }

    func setTargerController(controller: DetailViewController) {
        self.targetController = controller
    }

    func pushDetailVC(with index: Int) {
        guard let targetController = self.targetController else {
            return
        }
        self.controller?.navigationController?.pushViewController(targetController, animated: true)
    }
}
