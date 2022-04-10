//
//  Assembly.swift
//  TV
//
//  Created by Артем Соловьев on 08.04.2022.
//

import UIKit

final class Assembly {
    static func build() -> UIViewController {
        let model = Model()
        let router = Router()
        
        let presenter = Presenter(model: model, router: router)
        let controller = ViewController(presenter: presenter)
        
        let targetController = DetailViewController(model: model)
        
        router.setRootController(controller: controller )
        router.setTargerController(controller: targetController)
        
        return controller
    }
}
