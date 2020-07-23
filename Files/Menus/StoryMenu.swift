//
//  StoryMenu.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 05. 08..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class StoryMenu: SKScene {
    
    var leftCornerButton = SKSpriteNode()
    var leftCornerButtonImage: String?
    var leftCornerButtonPosX: CGFloat?
    var leftCornerButtonPosY: CGFloat?
    
    var rightCornerButton = SKSpriteNode()
    var rightCornerButtonImage: String?
    
    static var storyPageNumber = 1
    
    var buttonClickAudio = SKAudioNode(fileNamed: "ButtonClick.wav")
    
    override func didMove(to view: SKView) {
        
        Background.createBackGround(BackgroundImage: "StoryBackground\(StoryMenu.storyPageNumber)", forScene: self)
        
        leftCornerButton = ButtonGenerator.generateButton(imageName: leftCornerButtonImage!, scale: 0.1, position: CGPoint(x: leftCornerButtonPosX!, y: leftCornerButtonPosY!))
        rightCornerButton = ButtonGenerator.generateButton(imageName: rightCornerButtonImage!, scale: 0.1, position: CGPoint(x: -leftCornerButtonPosX!, y: leftCornerButtonPosY!))
        
        self.addChild(leftCornerButton)
        self.addChild(rightCornerButton)
        
        buttonClickAudio.autoplayLooped = false
        buttonClickAudio.name = "button"
        self.addChild(buttonClickAudio)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let pointOfTouch = touch.previousLocation(in: self)
            
            if leftCornerButton.contains(pointOfTouch) {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                let actionSequence = SKAction.sequence([fadeOut])
                SoundManager.playSound(sound: buttonClickAudio)
                leftCornerButton.run(actionSequence, completion: {
                    
                    if self.leftCornerButtonImage == "ReturnButton" {
                        
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            
                            scene.scaleMode = .fill
                            
                            self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.7))
                        }
                    }
                    else {
                        
                        if let storyMenu = StoryMenu(fileNamed: "StoryMenu") {
                            
                            StoryMenu.storyPageNumber -= 1
                            
                            storyMenu.leftCornerButtonPosX = self.leftCornerButton.position.x
                            storyMenu.leftCornerButtonPosY = self.leftCornerButton.position.y
                            
                            if StoryMenu.storyPageNumber == 1 {
                                storyMenu.leftCornerButtonImage = "ReturnButton"
                            }
                            else {
                                storyMenu.leftCornerButtonImage = "LastPageButton"
                            }
                            
                            storyMenu.rightCornerButtonImage = "NextPageButton"
                            
                            storyMenu.scaleMode = .fill
                            
                            self.view?.presentScene(storyMenu, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.3))
                        }
                    }
                })
            }
            
            else if rightCornerButton.contains(pointOfTouch) {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                let actionSequence = SKAction.sequence([fadeOut])
                SoundManager.playSound(sound: buttonClickAudio)
                
                rightCornerButton.run(actionSequence, completion: {
                
                    if self.rightCornerButtonImage == "NextPageButton" {
                        
                        if let storyMenu = StoryMenu(fileNamed: "StoryMenu") {
                            
                            storyMenu.leftCornerButtonPosX = self.leftCornerButton.position.x
                            storyMenu.leftCornerButtonPosY = self.leftCornerButton.position.y
                            
                            StoryMenu.storyPageNumber += 1
                            
                            if StoryMenu.storyPageNumber == 8 {
                                storyMenu.rightCornerButtonImage = "ReturnButton"
                            }
                            else {
                                storyMenu.rightCornerButtonImage = "NextPageButton"
                            }
                            
                            storyMenu.leftCornerButtonImage = "LastPageButton"
                            
                            storyMenu.scaleMode = .fill
                            
                            self.view?.presentScene(storyMenu, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.3))
                        }
                    }
                    else {
                        
                        StoryMenu.storyPageNumber = 1
                        
                        if let scene = MainMenu(fileNamed: "MainMenu") {
                            
                            scene.scaleMode = .fill
                            
                            self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.7))
                        }
                    }
            })
            }
            
        }
    }
}
