//
//  MovableObjects.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 13..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class MovableObject: SKSpriteNode {
    
    var animationSleepCounter: Int?     // Determines the switching time between two textures.
    var animationPhase: Int?            // The current texture the node has.
    
    init(imageNamed img: String,
        scalingTo scale: CGFloat,
        withPosition position: CGPoint,
        withPhysicsOf physicsCategory: Physics.PhysicsCategories?,
        addMovement movement: SKAction?) {
        
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        super.position = position
        super.zPosition = 1
        super.setScale(scale)
        super.name = img
        
        if let addedPhysicsCategory = physicsCategory {
            Physics.applyPhysicsBody(to: self, physicsCategory: addedPhysicsCategory)
        }
        
        if let addedMovement = movement {
            super.run(addedMovement, withKey: "movement")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateObject(newAnimationPhase phase: Int) {
        preconditionFailure("This method must be overridden")
    }
    
    func canAnimateObject(SleepCounter counter: Int) -> Bool {
        preconditionFailure("This method must be overridden")
    }
}
