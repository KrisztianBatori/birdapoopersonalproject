//
//  Physics.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 13..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class Physics {
    
    struct PhysicsBody {
        let PhysicsBodies = [
            PhysicsCategories.Man : SKPhysicsBody(circleOfRadius: 60, center: CGPoint(x: body.size.width * Man.manCirclePosX, y: body.size.height * 0.32)),
            PhysicsCategories.Poop : SKPhysicsBody(rectangleOf: CGSize(width: body.size.width * 0.30, height: body.size.height * 0.60))
        ]
    }
    
    enum PhysicsCategories: UInt32 {
        case None = 0
        case Man = 0b01
        case Poop = 0b10
    }
    
    static var body = SKSpriteNode()
    
    static func applyPhysicsBody(to node: SKSpriteNode, physicsCategory: PhysicsCategories) -> () {
        
        body = node
        
        node.physicsBody = PhysicsBody().PhysicsBodies[physicsCategory]
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.collisionBitMask = PhysicsCategories.None.rawValue
        node.physicsBody?.categoryBitMask = physicsCategory.rawValue
        node.physicsBody?.contactTestBitMask = physicsCategory.rawValue ^ 0b11 // So a man can only have contact with the poop, and vice-versa.
    }
    
}
