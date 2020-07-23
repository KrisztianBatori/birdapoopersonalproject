//
//  SkinMenu.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 05. 08..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class SkinMenu: SKScene {
    
    let pedestal = SKSpriteNode(imageNamed: "Pedestal")
    
    var initialSkinPrefix = UserDefaults.standard.value(forKey: "BirdSkin") as? String ?? CloudManager.attemptToRetrieveData(for: "BirdSkin") ?? String()
    
    var birdSkinPrefix = String()
    var bird: MovableObject? = nil
    var currentSkin = 1
    let skinTitles = [
        1 : "DEFAULT",
        2 : "PUNK",
        3 : "PRETTY",
        4 : "AVG. JOE",
        5 : "EDGY",
        6 : "PIRATE"
    ]
    let skinPrefixes = [
        1 : String(),
        2 : "Punk",
        3 : "Girl",
        4 : "Cap",
        5 : "Edgy",
        6 : "Pirate"
    ]
    var skinSwitched = true
    var skinTitle = SKLabelNode(fontNamed: "GillSans-UltraBold")
    var rightSwitch = SKSpriteNode()
    var leftSwitch = SKSpriteNode()
    
    var returnButton = SKSpriteNode()
    var returnButtonPosX: CGFloat?
    var returnButtonPosy: CGFloat?
    
    var buttonClickAudio = SKAudioNode(fileNamed: "ButtonClick.wav")
    
    let skinNode = SKSpriteNode(imageNamed: "SkinActiveState")
    var skinNodeClickable = false
    
    var challangeLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(red: 223/255.0, green: 246/255.0, blue: 255/255.0, alpha: 1.0)
        
        returnButton = ButtonGenerator.generateButton(imageName: "ReturnButton", scale: 0.1, position: CGPoint(x: returnButtonPosX!, y: returnButtonPosy!))
        
        self.addChild(returnButton)
        
        buttonClickAudio.autoplayLooped = false
        buttonClickAudio.name = "button"
        self.addChild(buttonClickAudio)
        
        designPedestal()
        self.addChild(pedestal)
        
        bird = Bird(imageNamed: "Bird1",
                    scalingTo: 0.55,
                    withPosition: CGPoint(x: 0, y: self.frame.size.height / 15),
                    withPhysicsOf: nil,
                    addMovement: nil)
        (bird as! Bird).disableSound()
        (bird as! Bird).birdSkinPrefix = birdSkinPrefix
        self.addChild(bird!)
        
        rightSwitch = ButtonGenerator.generateButton(imageName: "SkinSwitchingButton", scale: 0.47, position: CGPoint(x: (self.frame.size.width - self.frame.size.width * 0.68), y: (self.frame.size.height - self.frame.size.height * 0.58)))
        leftSwitch = ButtonGenerator.generateButton(imageName: "SkinSwitchingButton", scale: 0.47, position: CGPoint(x: -(self.frame.size.width - self.frame.size.width * 0.68), y: (self.frame.size.height - self.frame.size.height * 0.58)))
        leftSwitch.xScale = leftSwitch.xScale * -1
        
        self.addChild(rightSwitch)
        self.addChild(leftSwitch)
        
        designLabel(newText: skinTitles[currentSkin]!)
        skinTitle.position = CGPoint(x: 0, y: (self.frame.size.height - self.frame.size.height * 0.597))
        skinTitle.fontColor = .black
        skinTitle.fontSize = 65
        self.addChild(skinTitle)
        
        birdSkinPrefix = initialSkinPrefix
        if !birdSkinPrefix.isEmpty {
            skinNode.texture = SKTexture.init(imageNamed: "SkinPickState")
            skinNodeClickable = true
            birdSkinPrefix = String()
        }
        
        skinNode.position = CGPoint(x: 0, y: -(self.frame.size.height / 2.9))
        self.addChild(skinNode)
        
        designLabel()
        self.addChild(challangeLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        animateObjectIfCan(object: bird!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if skinSwitched {
            for touch in touches {
                
                let pointOfTouch = touch.previousLocation(in: self)
                
                if returnButton.contains(pointOfTouch) {
                    
                    let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                    let actionSequence = SKAction.sequence([fadeOut])
                    SoundManager.playSound(sound: buttonClickAudio)
                    returnButton.run(actionSequence, completion: {
                        
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            
                            scene.scaleMode = .fill
                            
                            self.view?.presentScene(scene, transition: SKTransition.reveal(with: SKTransitionDirection.down, duration: 0.7))
                        }
                    })
                }
                    
                else if rightSwitch.contains(pointOfTouch) {
                    skinSwitched = false
                    let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.2)
                    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
                    let actionSequence = SKAction.sequence([fadeOut, fadeIn])
                    SoundManager.playSound(sound: buttonClickAudio)
                    rightSwitch.run(actionSequence, completion: {
                        
                        self.currentSkin += 1
                        if self.currentSkin == 7 {
                            self.currentSkin = 1
                        }
                        
                        self.designLabel(newText: self.skinTitles[self.currentSkin]!)
                        self.changeSkin()
                        self.skinSwitched = true
                    })
                }
                    
                else if leftSwitch.contains(pointOfTouch) {
                    skinSwitched = false
                    let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.2)
                    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
                    let actionSequence = SKAction.sequence([fadeOut, fadeIn])
                    SoundManager.playSound(sound: buttonClickAudio)
                    leftSwitch.run(actionSequence, completion: {
                        
                        self.currentSkin -= 1
                        if self.currentSkin == 0 {
                            self.currentSkin = 6
                        }
                        
                        self.designLabel(newText: self.skinTitles[self.currentSkin]!)
                        self.changeSkin()
                        self.skinSwitched = true
                    })
                }
                
                else if skinNode.contains(pointOfTouch) && skinNodeClickable {
                    skinNode.texture = SKTexture(imageNamed: "SkinActiveState")
                    initialSkinPrefix = birdSkinPrefix
                    UserDefaults.standard.setValue(birdSkinPrefix, forKey: "BirdSkin")
                    UserDefaults.standard.synchronize()
                    CloudManager.saveToCloud(data: birdSkinPrefix, dataKey: "BirdSkin")
                }
        }
        }
    }
    
    func designPedestal() {
        pedestal.setScale(1.1)
        pedestal.position = CGPoint(x: 0, y: -(self.frame.size.height / 12))
    }
    
    func animateObjectIfCan(object: MovableObject) {
        if (object.canAnimateObject(SleepCounter: object.animationSleepCounter!)) {
            object.animationSleepCounter = 0
            object.animateObject(newAnimationPhase: object.animationPhase! + 0)
        }
        else {
            object.animationSleepCounter! += 1
        }
    }
    
    func designLabel(newText: String) {
        skinTitle.text = newText
    }
    
    func changeSkin() {
        birdSkinPrefix = skinPrefixes[currentSkin]!
        (bird as! Bird).birdSkinPrefix = birdSkinPrefix
        
        if initialSkinPrefix != birdSkinPrefix {
            
            var newSkinNodeTexture = "SkinPickState"
            skinNodeClickable = true
            var newChallangeLabelText = ""
            
            if currentSkin == 4 {
                if CloudManager.attemptToRetrieveData(for: "Challange1") == nil && UserDefaults.standard.value(forKey: "Challange1") == nil {
                    newChallangeLabelText = "Complete 'Challange 1' to unlock"
                    newSkinNodeTexture = "SkinLockedState"
                    skinNodeClickable = false
                }
            }
            else if currentSkin == 5 {
                if CloudManager.attemptToRetrieveData(for: "Challange2") == nil && UserDefaults.standard.value(forKey: "Challange2") == nil {
                    newChallangeLabelText = "Complete 'Challange 2' to unlock"
                    newSkinNodeTexture = "SkinLockedState"
                    skinNodeClickable = false
                }
            }
            else if currentSkin == 6 {
                if CloudManager.attemptToRetrieveData(for: "Challange3") == nil && UserDefaults.standard.value(forKey: "Challange3") == nil {
                    newChallangeLabelText = "Complete 'Challange 3' to unlock"
                    newSkinNodeTexture = "SkinLockedState"
                    skinNodeClickable = false
                }
            }
            challangeLabel.text = newChallangeLabelText
            challangeLabel.fontSize = 37
            skinNode.texture = SKTexture(imageNamed: newSkinNodeTexture)
        }
        else {
            skinNode.texture = SKTexture(imageNamed: "SkinActiveState")
            skinNodeClickable = false
        }
    }
    
    func designLabel() {
        challangeLabel.zPosition = 2
        challangeLabel.fontName = "AvenirNext-HeavyItalic"
        challangeLabel.fontSize = 45
        challangeLabel.fontColor = UIColor(red: 3/255.0, green: 31/255.0, blue: 170/255.0, alpha: 1.0)
        challangeLabel.position = CGPoint(x: 0, y: (self.frame.size.height - self.frame.size.height * 0.7))
    }
}
