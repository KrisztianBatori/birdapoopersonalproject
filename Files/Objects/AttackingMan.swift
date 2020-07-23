//
//  AttackingMan.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 03. 05..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class attackingMan: GameScene {
    static var man: Man?
    static var assignedPoop: Poop?
    
    static func assignPoopToAttackingMan(in scene: GameScene, aimingAt bird: Bird) {
        let poop = Poop(imageNamed: "Poop",
                        scalingTo: 0.14,
                        withPosition: CGPoint(x: scene.frame.size.width * 0.615, y: -(bird.position.y * 1.63)),
                        withPhysicsOf: nil,
                        addMovement: SKAction.sequence([
                            SKAction.move(to: CGPoint(x: -scene.frame.size.width * 0.408, y: -(bird.position.y * 1.63)), duration: TimeInterval(4.6)),
                            SKAction.run {
                                if (attackingMan.man?.manImageName?.first)! != "P" {
                                    scene.isGameOver = true
                                }
                                else {
                                    scene.isGameOver = false
                                }
                            },
                        ]))
        poop.zPosition = 2
        poop.name = "Throwed poop"
        scene.addChild(poop)
        attackingMan.assignedPoop = poop
    }
    
    static func missThrow(in scene: GameScene, bird: Bird) {
        attackingMan.assignedPoop!.run(SKAction.sequence([
            SKAction.run { SoundManager.playSound(sound: GameScene.audios[9]) },
            SKAction.move(to: CGPoint(x: attackingMan.man!.position.x * 0.8, y: -(bird.position.y * 1.63)), duration: 0.2),
            SKAction.run {
                attackingMan.assignedPoop?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: attackingMan.assignedPoop!.size.width, height: attackingMan.assignedPoop!.size.height))
                Physics.applyPhysicsBody(to: attackingMan.assignedPoop!, physicsCategory: Physics.PhysicsCategories.Poop)
            },
            SKAction.move(to: CGPoint(x: scene.frame.size.width * 0.615, y: -(bird.position.y * 1.63)), duration: 1),
        ]))
    }
    
    static func throwAt(in scene: GameScene, bird: Bird) {
        GameScene.audios[2].run(SKAction.stop())
        attackingMan.assignedPoop!.run(SKAction.sequence([
            SKAction.run { SoundManager.playSound(sound: GameScene.audios[9]) },
            SKAction.move(to: CGPoint(x: bird.position.x * 0.7, y: bird.position.y * 1.2), duration: TimeInterval(0.85)),
            SKAction.run { SoundManager.playSound(sound: GameScene.audios[1]) },
            SKAction.colorize(withColorBlendFactor: 1, duration: 0),
            SKAction.removeFromParent(),
            SKAction.run {
                scene.gameOver = scene.isGameOver!
            }
        ]))
    }
}
