//
//  SettingsMenu.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 04. 02..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class SettingsMenu: SKScene {
    
    var volumePower = SKLabelNode()
    var volumeUpButton = SKSpriteNode(imageNamed: "VolumeAdjuster")
    var volumeDownButton = SKSpriteNode(imageNamed: "VolumeAdjuster")
    
    var toggleButtons = [UserSetButton]()
    var returnButton = SKSpriteNode()
    var returnButtonPosX: CGFloat?
    var returnButtonPosy: CGFloat?
    
    var advancedSettingButton = SKSpriteNode()
    
    var buttonClickAudio = SKAudioNode(fileNamed: "ButtonClick.wav")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "SettingsMenuBackground")
        background.name = "Background"
        background.size = CGSize(width: (scene!.frame.size.width), height: scene!.frame.size.height)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        
        self.addChild(background)
        
        
        self.addChild(designLabel(SKLabelNode(), WithText: "TUTORIAL", withPosition: CGPoint(x: -(self.frame.size.width - self.frame.size.width * 0.85), y: -(self.frame.size.height - self.frame.size.height * 1.25)), withFontSize: 87))
        self.addChild(designLabel(SKLabelNode(), WithText: "FPS", withPosition: CGPoint(x: -(self.frame.size.width - self.frame.size.width * 0.84), y: -(self.frame.size.height - self.frame.size.height * 1.05)), withFontSize: 110))
        self.addChild(designLabel(SKLabelNode(), WithText: "VOLUME", withPosition: CGPoint(x: -(self.frame.size.width - self.frame.size.width * 0.839), y: -(self.frame.size.height - self.frame.size.height * 0.85)), withFontSize: 95))
        
        self.addChild(designLabel(volumePower,
                                  WithText: UserDefaults.standard.value(forKey: "UserVolumePower") as? String ?? "50",
                                  withPosition: CGPoint(x: -(self.frame.size.width - self.frame.size.width * 1.333), y: -(self.frame.size.height - self.frame.size.height * 0.8542)),
                                  withFontSize: 70))
        UserDefaults.standard.setValue(volumePower.text, forKey: "UserVolumePower")
        UserDefaults.standard.synchronize()
        
        toggleButtons = [UserSetButton(key: "TutorialState", defaultState: "ToggleButton1"),
                         UserSetButton(key: "FPSState", defaultState: "ToggleButton2")]
        
        toggleButtons[0].createButton(posX: -(self.frame.size.width - self.frame.size.width * 1.33), posY: -(self.frame.size.height - self.frame.size.height * 1.2695))
        toggleButtons[1].createButton(posX: -(self.frame.size.width - self.frame.size.width * 1.33), posY: -(self.frame.size.height - self.frame.size.height * 1.0728))
        
        returnButton = ButtonGenerator.generateButton(imageName: "ReturnButton", scale: 0.1, position: CGPoint(x: returnButtonPosX!, y: returnButtonPosy!))
        advancedSettingButton = ButtonGenerator.generateButton(imageName: "AdvancedSettingsButton", scale: 1, position: CGPoint(x: 0, y: -(self.frame.size.height - self.frame.size.height * 0.695)))
        
        
        positionVolumeButton(button: volumeUpButton, position: CGPoint(x: -(self.frame.size.width - self.frame.size.width * 1.333), y: -(self.frame.size.height - self.frame.size.height * 0.92)))
        positionVolumeButton(button: volumeDownButton, position: CGPoint(x: -(self.frame.size.width - self.frame.size.width * 1.333), y: -(self.frame.size.height - self.frame.size.height * 0.8185)), isRotated: true)
        
        if volumePower.text! == "100" {
            volumeUpButton.isHidden = true
        }
        else if volumePower.text! == "0" {
            volumeDownButton.isHidden = true
        }
        
        self.addChild(returnButton)
        self.addChild(advancedSettingButton)
        for i in 0...1 {
            self.addChild(toggleButtons[i].button)
        }
        
        buttonClickAudio.autoplayLooped = false
        buttonClickAudio.name = "button"
        self.addChild(buttonClickAudio)
        
        if !GameViewController.fullVersionEnabled {
            advancedSettingButton.isHidden = true
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
                    
                    if let scene = MainMenu(fileNamed: "MainMenu") {
                        
                        scene.scaleMode = .fill
                        
                        self.view?.presentScene(scene, transition: SKTransition.doorway(withDuration: 0.6))
                    }
                })
            }
            else if toggleButtons[0].button.contains(pointOfTouch) || toggleButtons[1].button.contains(pointOfTouch) {
                
                var index: Int
                
                if toggleButtons[0].button.contains(pointOfTouch) {
                    index = 0
                }
                else {
                    index = 1
                }
                SoundManager.playSound(sound: buttonClickAudio)
                toggleButtons[index].changeState()
                toggleButtons[index].button.texture = SKTexture.init(imageNamed: toggleButtons[index].buttonState!)
            }
            else if volumeUpButton.contains(pointOfTouch) && volumeUpButton.isHidden == false {
                SoundManager.playSound(sound: buttonClickAudio)
                volumeUpButton.run(SKAction.sequence([
                    SKAction.fadeAlpha(by: -0.8, duration: 0.2),
                    SKAction.fadeAlpha(by: 0.8, duration: 0.2)
                    ]))
                let newVolumePower = Int(volumePower.text!)! + 10
                volumePower.text = String(newVolumePower)
                UserDefaults.standard.setValue(volumePower.text, forKey: "UserVolumePower")
                UserDefaults.standard.synchronize()
                SongManager.shared.adjustVolume(volume: Float(newVolumePower) / 100)
                
                if volumePower.text! == "100" {
                    volumeUpButton.isHidden = true
                }
                
                if volumePower.text! == "10" {
                    volumeDownButton.isHidden = false
                }
            }
            else if volumeDownButton.contains(pointOfTouch) && volumeDownButton.isHidden == false {
                SoundManager.playSound(sound: buttonClickAudio)
                volumeDownButton.run(SKAction.sequence([
                    SKAction.fadeAlpha(by: -0.8, duration: 0.2),
                    SKAction.fadeAlpha(by: 0.8, duration: 0.2)
                    ]))
                let newVolumePower = Int(volumePower.text!)! - 10
                volumePower.text = String(newVolumePower)
                UserDefaults.standard.setValue(volumePower.text, forKey: "UserVolumePower")
                UserDefaults.standard.synchronize()
                SongManager.shared.adjustVolume(volume: Float(newVolumePower) / 100)
                
                if volumePower.text! == "0" {
                    volumeDownButton.isHidden = true
                }
                
                if volumePower.text! == "90" {
                    volumeUpButton.isHidden = false
                }
            }
            else if advancedSettingButton.contains(pointOfTouch) && advancedSettingButton.isHidden == false {
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                let actionSequence = SKAction.sequence([fadeOut])
                SoundManager.playSound(sound: buttonClickAudio)
                advancedSettingButton.run(actionSequence, completion: {
                    
                    if let scene = AdvancedSettingsMenu(fileNamed: "AdvancedSettingsMenu") {
                        
                        scene.returnButtonPosX = self.returnButton.position.x
                        scene.returnButtonPosy = self.returnButton.position.y
                        
                        scene.scaleMode = .fill
                        
                        self.view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.6))
                    }
                })
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
    
    func positionVolumeButton(button: SKSpriteNode, position: CGPoint, isRotated: Bool = false) {
        button.setScale(0.5)
        button.position = position
        if isRotated {
            button.zRotation = .pi
        }
        self.addChild(button)
    }
    
}

