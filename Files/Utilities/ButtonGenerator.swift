//
//  ButtonGenerator.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 22..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class ButtonGenerator {
    
    static func generateButton(imageName: String, scale: CGFloat, position: CGPoint) -> (SKSpriteNode) {
        let node = SKSpriteNode(imageNamed: imageName)
        node.setScale(scale)
        node.position = position
        node.zPosition = 1
        return node
    }
    
}
