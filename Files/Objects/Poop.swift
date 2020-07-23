//
//  Poop.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 14..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class Poop: MovableObject {
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateObject(newAnimationPhase phase: Int) {
        // Empty function since the 'Poop' doesn't have animation.
    }
    
    override func canAnimateObject(SleepCounter counter: Int) -> Bool {
        return false
    }
}
