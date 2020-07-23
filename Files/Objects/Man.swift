//
//  Man.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 14..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class Man: MovableObject {
    
    var designPattern: Int?
    var manImageName: String?
    var manAttacking = false
    static var manCirclePosX: CGFloat = 0.02
    static var didGetPooped = true
    
    override init(imageNamed img: String,
                  scalingTo scale: CGFloat,
                  withPosition position: CGPoint,
                  withPhysicsOf physicsCategory: Physics.PhysicsCategories?,
                  addMovement movement: SKAction?) {
        
        super.init(imageNamed: img,
                   scalingTo: scale,
                   withPosition: position,
                   withPhysicsOf: physicsCategory,
                   addMovement: movement)
        
        animationSleepCounter = 1
        animationPhase = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateObject(newAnimationPhase phase: Int) {
        if (phase < 5) {
            var firstNumber = 0
            for character in manImageName!.unicodeScalars {
                var endLoop = false
                if NSCharacterSet.decimalDigits.contains(character) {
                    firstNumber = Int(character.value) - 48
                    endLoop = true
                }
                if endLoop {
                    break
                }
            }
            let texturePrefix = String(Array(manImageName!)[0..<manImageName!.firstIndex(of: Character(String(firstNumber)))!.encodedOffset])
            self.texture = SKTexture.init(imageNamed: texturePrefix + "\(designPattern!)S\(phase)")
        }
    }
    
    override func canAnimateObject(SleepCounter counter: Int) -> Bool {
        return counter == 5 ? true : false
    }
    
    public func setDesignPattern(to designPattern: Int) {
        self.designPattern = designPattern
    }
    
    public func setGetPooped() {
        Man.didGetPooped = true
    }
    
    static func determinePlayerScore(scoreBoard: ScoreBoard) {
        if !Man.didGetPooped {
            while !ScoreBoard.isScoreCalculating {
                scoreBoard.playerScore -= 1
                break
            }
        }
    }
    
    public func blindAttackingMan() {
        var newManImageName = self.manImageName
        newManImageName!.insert("P", at: newManImageName!.startIndex)
        self.manImageName = newManImageName
        self.texture = SKTexture(imageNamed: newManImageName!)
    }
    
    public func blindMan() {
        var newManImageName = self.manImageName
        newManImageName!.insert("O", at: newManImageName!.startIndex)
        newManImageName! = String(newManImageName!.dropLast())
        newManImageName!.insert("1", at: newManImageName!.endIndex)
        self.manImageName = newManImageName
        self.texture = SKTexture(imageNamed: newManImageName!)
        self.zPosition = 0
        self.removeAllActions()
        self.run(SKAction.rotate(byAngle: -3, duration: 0.8))
        self.run(SKAction.moveBy(x: 40, y: -50, duration: 0.4), completion: {
            self.run(SKAction.moveBy(x: 80, y: -290, duration: 0.4), completion: {
                Man.didGetPooped = false
                self.run(SKAction.removeFromParent())
            })
        })
    }
    
}
