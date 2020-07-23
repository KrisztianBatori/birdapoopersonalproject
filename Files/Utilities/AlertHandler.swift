//
//  AlertHandler.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 09. 14..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKScene

class AlertHandler {
    
    static func showAlert(on scene: SKScene, title: String, message: String, preferredStyle: UIAlertController.Style, animated: Bool, delay: Double, options: AlertOption...) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let wait = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: wait) {
            scene.view?.window?.rootViewController!.present(alert, animated: animated)
        }
        
        for option in options {
            alert.addAction(UIAlertAction(title: option.title, style: option.style, handler: option.handler))
        }
        
    }
}
