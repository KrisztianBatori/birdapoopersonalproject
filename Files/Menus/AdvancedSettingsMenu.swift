//
//  AdvancedSettingsMenu.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 04. 28..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class AdvancedSettingsMenu: SKScene {
    
    var returnButton = SKSpriteNode()
    var returnButtonPosX: CGFloat?
    var returnButtonPosy: CGFloat?
    
    var toggleButtons = [UserSetButton]()
    
    var buttonClickAudio = SKAudioNode(fileNamed: "ButtonClick.wav")
    var soundList = SKSpriteNode(imageNamed: "SoundList")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "SettingsMenuBackground")
        background.name = "Background"
        background.size = CGSize(width: (scene!.frame.size.width), height: scene!.frame.size.height)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        
        self.addChild(background)
        
        returnButton = ButtonGenerator.generateButton(imageName: "ReturnButton", scale: 0.1, position: CGPoint(x: returnButtonPosX!, y: returnButtonPosy!))
        
        self.addChild(returnButton)
        
        buttonClickAudio.autoplayLooped = false
        buttonClickAudio.name = "button"
        self.addChild(buttonClickAudio)
        
        self.addChild(designLabel(SKLabelNode(), WithText: "SOUNDS", withPosition: CGPoint(x: 0, y: -(self.frame.size.height - self.frame.size.height * 1.37)), withFontSize: 110))
        
        soundList.setScale(1.5)
        soundList.position.y = -(self.frame.size.height - self.frame.size.height * 0.9)
        self.addChild(soundList)
        
        toggleButtons = [UserSetButton(key: "show", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "lose", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "hit", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "ground", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "get", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "count", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "hitB", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "poop", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "throw", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "button", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "wing", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "grade", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "start", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "coo", defaultState: "v2ToggleButton1"),
                         UserSetButton(key: "background", defaultState: "v2ToggleButton1")]
        
        toggleButtons[0].createButton(posX: (self.frame.size.width - self.frame.size.width * 1.045), posY: -(self.frame.size.height - self.frame.size.height * 1.274))
        toggleButtons[1].createButton(posX: (self.frame.size.width - self.frame.size.width * 1.045), posY: -(self.frame.size.height - self.frame.size.height * 1.194))
        toggleButtons[2].createButton(posX: (self.frame.size.width - self.frame.size.width * 1.045), posY: -(self.frame.size.height - self.frame.size.height * 1.105))
        toggleButtons[3].createButton(posX: (self.frame.size.width - self.frame.size.width * 1.045), posY: -(self.frame.size.height - self.frame.size.height * 1.022))
        toggleButtons[4].createButton(posX: (self.frame.size.width - self.frame.size.width * 1.045), posY: -(self.frame.size.height - self.frame.size.height * 0.943))
        toggleButtons[5].createButton(posX: (self.frame.size.width - self.frame.size.width * 1.045), posY: -(self.frame.size.height - self.frame.size.height * 0.866))
        toggleButtons[6].createButton(posX: (self.frame.size.width - self.frame.size.width * 1.045), posY: -(self.frame.size.height - self.frame.size.height * 0.788))
        
        toggleButtons[7].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.6), posY: -(self.frame.size.height - self.frame.size.height * 1.274))
        toggleButtons[8].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.6), posY: -(self.frame.size.height - self.frame.size.height * 1.194))
        toggleButtons[9].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.6), posY: -(self.frame.size.height - self.frame.size.height * 1.105))
        toggleButtons[10].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.6), posY: -(self.frame.size.height - self.frame.size.height * 1.022))
        toggleButtons[11].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.6), posY: -(self.frame.size.height - self.frame.size.height * 0.943))
        toggleButtons[12].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.6), posY: -(self.frame.size.height - self.frame.size.height * 0.866))
        toggleButtons[13].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.6), posY: -(self.frame.size.height - self.frame.size.height * 0.788))
        
        toggleButtons[14].createButton(posX: (self.frame.size.width - self.frame.size.width * 0.7), posY: -(self.frame.size.height - self.frame.size.height * 0.6755))
        
        for i in 0...14 {
            self.addChild(toggleButtons[i].button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let pointOfTouch = touch.previousLocation(in: self)
            
            if returnButton.contains(pointOfTouch) {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                let actionSequence = SKAction.sequence([fadeOut])
                SoundManager.playSound(sound: buttonClickAudio)
                returnButton.run(actionSequence, completion: {
                    
                    if let scene = SettingsMenu(fileNamed: "SettingsMenu") {
                        
                        scene.returnButtonPosX = self.returnButton.position.x
                        scene.returnButtonPosy = self.returnButton.position.y
                        
                        scene.scaleMode = .fill
                        
                        self.view?.presentScene(scene, transition: SKTransition.doorsCloseHorizontal(withDuration: 0.6))
                    }
                })
            }
            else if toggleButtons[0].button.contains(pointOfTouch) || toggleButtons[1].button.contains(pointOfTouch) || toggleButtons[2].button.contains(pointOfTouch) || toggleButtons[3].button.contains(pointOfTouch) || toggleButtons[4].button.contains(pointOfTouch) || toggleButtons[5].button.contains(pointOfTouch) || toggleButtons[6].button.contains(pointOfTouch) || toggleButtons[7].button.contains(pointOfTouch) || toggleButtons[8].button.contains(pointOfTouch) || toggleButtons[9].button.contains(pointOfTouch) || toggleButtons[10].button.contains(pointOfTouch) || toggleButtons[11].button.contains(pointOfTouch) || toggleButtons[12].button.contains(pointOfTouch) || toggleButtons[13].button.contains(pointOfTouch) || toggleButtons[14].button.contains(pointOfTouch) {
                
                SoundManager.playSound(sound: buttonClickAudio)
                
                var index: Int = 14
                
                if toggleButtons[0].button.contains(pointOfTouch) {
                    index = 0
                }
                else if toggleButtons[1].button.contains(pointOfTouch) {
                    index = 1
                }
                else if toggleButtons[2].button.contains(pointOfTouch) {
                    index = 2
                }
                else if toggleButtons[3].button.contains(pointOfTouch) {
                    index = 3
                }
                else if toggleButtons[4].button.contains(pointOfTouch) {
                    index = 4
                }
                else if toggleButtons[5].button.contains(pointOfTouch) {
                    index = 5
                }
                else if toggleButtons[6].button.contains(pointOfTouch) {
                    index = 6
                }
                else if toggleButtons[7].button.contains(pointOfTouch) {
                    index = 7
                }
                else if toggleButtons[8].button.contains(pointOfTouch) {
                    index = 8
                }
                else if toggleButtons[9].button.contains(pointOfTouch) {
                    index = 9
                }
                else if toggleButtons[10].button.contains(pointOfTouch) {
                    index = 10
                }
                else if toggleButtons[11].button.contains(pointOfTouch) {
                    index = 11
                }
                else if toggleButtons[12].button.contains(pointOfTouch) {
                    index = 12
                }
                else if toggleButtons[13].button.contains(pointOfTouch) {
                    index = 13
                }
                
                toggleButtons[index].changeState(buttonVersion: "v2")
                toggleButtons[index].button.texture = SKTexture.init(imageNamed: toggleButtons[index].buttonState!)
                
                if toggleButtons[14].button.contains(pointOfTouch) {
                    SongManager.shared.stop()
                    SongManager.shared.play()
                }
                
            }
        }
    }
    
    func designLabel(_ label: SKLabelNode, WithText text: String, withPosition position: CGPoint, withFontSize fontSize: CGFloat) -> SKLabelNode {
        label.fontName = "Copperplate-Bold"
        label.fontSize = fontSize
        label.fontColor = .black
        label.text = text
        label.position = position
        label.zPosition = 1
        return label
    }
    
}
