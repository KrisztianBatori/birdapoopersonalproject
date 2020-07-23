//
//  UserSettings.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 04. 07..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class UserSetButton {
    
    var key: String
    var buttonState: String?
    var button = SKSpriteNode()
    
    init(key: String, defaultState: String) {
        if let state = UserDefaults.standard.value(forKey: key) as? String {
            buttonState = state
        }
        else {
            buttonState = defaultState
        }
        self.key = key
    }
    
    func createButton(posX: CGFloat, posY: CGFloat) {
        button = ButtonGenerator.generateButton(imageName: buttonState!, scale: 0.1, position: CGPoint(x: posX, y: posY))
    }
    
    func changeState(buttonVersion: String = String()) {
        let state = buttonState!.last!
        buttonState = buttonVersion + "ToggleButton\((Int(String(state))!) ^ 0b11)"
        
        UserDefaults.standard.setValue(buttonState, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
