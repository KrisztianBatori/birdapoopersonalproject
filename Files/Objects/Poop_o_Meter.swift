//
//  Poop_o_Meter.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 19..
//  Copyright © 2019. Golden Games. All rights reserved.
//


/*
 
 This class sets the "falling speed" of the poop. The speed is set by the Poop-o-meter's current texture number.
 
 */

import SpriteKit.SKSpriteNode

class Poop_o_Meter: MovableObject {
    
    static var animationDirector = 1        // If its 0, the arrow in the Poop-o-meter goes left, otherwise to right.
    
    var animationCounter = 2
    var eventCounter = 0
    var eventTriggerer = Int.random(in: 350...400)
    var eventActivated = false
    var isJammed = false
    
    let poopSpeedDict: [Int:TimeInterval] = [1 : 3.25,
                                             2 : 3,
                                             3 : 2.75,
                                             4 : 2.5,
                                             5 : 2.25,
                                             6 : 2,
                                             7 : 1.75,
                                             8 : 1.5,
                                             9 : 1.25,
                                             10 : 1,
                                             11 : 0.75]
    
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
        animationPhase = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateObject(newAnimationPhase phase: Int) {
        if !isJammed {
            self.texture = SKTexture.init(imageNamed: "PS\(phase)")
            animationPhase = phase
            if phase == 11 {
                Poop_o_Meter.animationDirector = -1
            }
            else if phase == 1 {
                Poop_o_Meter.animationDirector = 1
            }
        }
    }
    
    override func canAnimateObject(SleepCounter counter: Int) -> Bool {
        if counter > 2 || counter < 0 || isJammed {
            animationSleepCounter = -1
            return false
        }
        else {
            return counter == animationCounter ? true : false
        }
    }
    
    func getPoopSpeed() -> TimeInterval {
        return poopSpeedDict[animationPhase!]!
    }
    
    func incrementEventCounter() {
        eventCounter += 1
        
        if (eventCounter == eventTriggerer) {
            if !eventActivated {
                switch Int.random(in: 1...5) {
                case 1...3:
                    speedUpPoopOMeter()
                case 4:
                    hidePoopOMeter()
                default:
                    jamPoopOMeter()
                }
                eventActivated = true
            }
            else {
                animationCounter = 2
                self.isHidden = false
                isJammed = false
                eventActivated = false
            }
            resetAfterEvent()
        }
    }
    
    func resetAfterEvent() {
        eventCounter = 0
        eventTriggerer = Int.random(in: 300...350)
    }
    
    func speedUpPoopOMeter() {
        animationCounter = 1
    }
    
    func hidePoopOMeter() {
        self.isHidden = true
    }
    
    func jamPoopOMeter() {
        isJammed = true
    }
}
