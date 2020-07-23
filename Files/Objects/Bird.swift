//
//  Bird.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 14..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit

class Bird: MovableObject {
    
    var birdFallingAnimationDone = false
    var birdFallingAnimationSleepCounter = 0
    var cooSoundCounter = 0
    var cooSoundTriggerer = Int.random(in: 50...150)
    var soundEnabled = true
    var birdSkinPrefix: String?
    
    override init(imageNamed img: String,
                  scalingTo scale: CGFloat,
                  withPosition position: CGPoint,
                  withPhysicsOf physicsCategory: Physics.PhysicsCategories?,
                  addMovement movement: SKAction?) {
        
        super.init(imageNamed: img,
                   scalingTo: scale,
                   withPosition: position,
                   withPhysicsOf: nil,
                   addMovement: nil)
        
        animationSleepCounter = 0
        animationPhase = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateObject(newAnimationPhase phase: Int) {
        
        if soundEnabled {
            cooSoundCounter += 1
            if cooSoundCounter == cooSoundTriggerer {
                cooSoundCounter = 0
                cooSoundTriggerer = Int.random(in: 50...150)
                SoundManager.playSound(sound: GameScene.audios[3])
            }
        }
        
        self.texture = SKTexture.init(imageNamed: "\(birdSkinPrefix!)Bird\(phase)")
        switch phase {
        case 1, 4:
            if soundEnabled {
                SoundManager.playSound(sound: GameScene.audios[2])
            }
            super.animationPhase = 2
        case 2, 3:
            super.animationPhase = 1
        default:
            break
        }
        
        if (phase == 3 || phase == 4) {
            super.animationSleepCounter = -3
        }
    }
    
    override func canAnimateObject(SleepCounter counter: Int) -> Bool {
        return counter == 5 ? true : false
    }
    
    func poopWithBird(in scene: SKScene, with speed: TimeInterval, affected scoreBoard: ScoreBoard, with poopSkin: String) -> MovableObject {
        return Poop(imageNamed: poopSkin,
                    scalingTo: 0.16,
                    withPosition: CGPoint(x: self.position.x + self.position.x * 0.4, y: 0 + self.position.y * 0.45),
                    withPhysicsOf: .Poop,
                    addMovement: SKAction.sequence([
                        SKAction.moveTo(y: -scene.frame.size.height * 0.27, duration: speed),
                        SKAction.run {
                            while !ScoreBoard.isScoreCalculating {
                                scoreBoard.playerScore -= 1
                                break
                            }
                        },
                        SKAction.run { SoundManager.playSound(sound: GameScene.audios[10]) },
                        SKAction.removeFromParent()
                        ])
        )
    }
    
    func fallToGround() {
        self.run(SKAction.rotate(byAngle: -0.05, duration: 0))
        self.run(SKAction.moveBy(x: 7, y: -18, duration: 0))
        birdFallingAnimationSleepCounter += 1
        if birdFallingAnimationSleepCounter == 47 {
            birdFallingAnimationDone = true
            SoundManager.playSound(sound: GameScene.audios[5])
        }
    }
    
    func disableSound() {
        soundEnabled = false
    }
}
