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
    func pushDetailVC(with channel: Channel)
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

    func pushDetailVC(with channel: Channel) {
        guard let targetController = self.targetController else {
            return
        }
        targetController.modalPresentationStyle = .fullScreen
        targetController.setSelectedChannel(channel: channel)
//        self.controller?.navigationController?.pushViewController(targetController, animated: false)
        self.controller?.present(targetController, animated: true)
    }
}
