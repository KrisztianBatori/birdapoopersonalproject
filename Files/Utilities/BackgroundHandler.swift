//
//  BackgroundHandler.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 12..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class Background {
    
    static func createBackGround(BackgroundImage img: String, forScene scene: SKScene) {
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: img)
            background.name = "Background"
            background.size = CGSize(width: (scene.frame.size.width), height: scene.frame.size.height)
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.zPosition = -1
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 0)
            scene.addChild(background)
        }
    }
    
    static func mutateBackground(ofScene scene: SKScene) {
        scene.enumerateChildNodes(withName: "Background", using: ({(
            node, error) in
            
            node.position.x -= 2
            if (node.position.x < -(scene.size.width)) {
                node.position.x += scene.size.width * 3
            }
            
        }))
    }
}
