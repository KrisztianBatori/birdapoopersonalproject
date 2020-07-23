//
//  MainMenu.swift
//  Bird-A-Poo
//
//  Created by Bathory Christian on 08/02/2019.
//  Copyright © 2019 Golden Games. All rights reserved.
//


import SpriteKit.SKSpriteNode
import Foundation

class MainMenu: SKScene {
    
    var playButton = SKSpriteNode()
    var title = SKSpriteNode()
    var buyButton = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    var infoButton = SKSpriteNode()
    var skinsButton = SKSpriteNode()
    var storyButton = SKSpriteNode()
    var bestScore = SKLabelNode()
    var challangeSideBar = SKSpriteNode()
    var challangeSideBarOpen = false
    var challangeProgressIcons = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
    
    var buttonClickAudio = SKAudioNode(fileNamed: "ButtonClick.wav")
    
    override func didMove(to view: SKView) {
        
        Background.createBackGround(BackgroundImage: "Background", forScene: self)
        
        SongManager.shared.play()
        
        playButton = ButtonGenerator.generateButton(imageName: "PlayButton", scale: 0.16, position: CGPoint(x: 0, y: self.frame.size.height / 20))
        title = ButtonGenerator.generateButton(imageName: "MainMenuTitle", scale: 0.48, position: CGPoint(x: 0, y: -(self.frame.size.height - self.frame.size.height * 1.36)))
        buyButton = ButtonGenerator.generateButton(imageName: "BuyButton", scale: 0.26, position: CGPoint(x: 0, y: title.position.y - title.position.y * 1.55))
        settingsButton = ButtonGenerator.generateButton(imageName: "SettingsButton", scale: 0.1, position: CGPoint(x: -(self.frame.size.width * 0.38), y: buyButton.position.y + buyButton.position.y * 1.2))
        infoButton = ButtonGenerator.generateButton(imageName: "InfoButton", scale: 0.1, position: CGPoint(x: self.frame.size.width * 0.38, y: buyButton.position.y + buyButton.position.y * 1.2088))
        skinsButton = ButtonGenerator.generateButton(imageName: "SkinButton", scale: 0.4, position: CGPoint(x: -(self.frame.size.width * 0.22), y: -(self.frame.size.height / 4.5)))
        storyButton = ButtonGenerator.generateButton(imageName: "StoryButton", scale: 0.4, position: CGPoint(x: (self.frame.size.width * 0.22), y: -(self.frame.size.height / 4.5)))
        
        self.addChild(playButton)
        self.addChild(title)
        self.addChild(buyButton)
        self.addChild(settingsButton)
        self.addChild(skinsButton)
        self.addChild(storyButton)
        self.addChild(infoButton)
        
        buttonClickAudio.autoplayLooped = false
        buttonClickAudio.name = "button"
        self.addChild(buttonClickAudio)
        
        skinsButton.isHidden = true
        storyButton.isHidden = true
        
        if GameViewController.fullVersionEnabled {
            buyButton.isHidden = true
            skinsButton.isHidden = false
            storyButton.isHidden = false
        }
        
        designLabel()
        self.addChild(bestScore)
        
        designChallangeSideBar()
        self.addChild(challangeSideBar)
        
        designChallangeProgressIcon(icon: &challangeProgressIcons[0], position: CGPoint(x: self.frame.size.width * 0.46, y: -(self.frame.size.height - self.frame.size.height * 1.059)), challangeNumber: 1)
        designChallangeProgressIcon(icon: &challangeProgressIcons[1], position: CGPoint(x: self.frame.size.width * 0.46, y: 0), challangeNumber: 2)
        designChallangeProgressIcon(icon: &challangeProgressIcons[2], position: CGPoint(x: self.frame.size.width * 0.46, y: (self.frame.size.height - self.frame.size.height * 1.059)), challangeNumber: 3)
        
        if !CloudManager.isUserSignedToiCloud() {
            AlertHandler.showAlert(on: self, title: "Sign in to iCloud", message: "Your highscore and challange progress will be kept even when deleting the app or switching device.", preferredStyle: UIAlertController.Style.alert, animated: true, delay: 1, options:
                AlertOption.init(optionTitle: "Open Settings", optionStyle: UIAlertAction.Style.cancel, optionHandler: {
                    (action) in
                    let settingsUrl = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl!)
                    } else {
                        UIApplication.shared.openURL(settingsUrl!)
                    }
                }),
                AlertOption.init(optionTitle: "Cancel", optionStyle: UIAlertAction.Style.default, optionHandler: nil))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        Background.mutateBackground(ofScene: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let pointOfTouch = touch.previousLocation(in: self)
            
            if playButton.contains(pointOfTouch) && !challangeSideBarOpen {
                
                SongManager.shared.stop()
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                
                let actionSequence = SKAction.sequence([fadeOut])
                
                SceneTransitionSongManager.shared.play()
                
                playButton.run(actionSequence, completion: {
                    
                    if let GameScene = GameScene(fileNamed: "GameScene") {
                        
                        GameScene.scaleMode = .fill
                        
                        self.view?.presentScene(GameScene, transition: SKTransition.fade(withDuration: 0.8))
                    }
                })
            }
            
            else if settingsButton.contains(pointOfTouch) && !challangeSideBarOpen {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                
                let actionSequence = SKAction.sequence([fadeOut])
                
                SoundManager.playSound(sound: buttonClickAudio)
                
                settingsButton.run(actionSequence, completion: {
                    
                    if let SettingsMenu = SettingsMenu(fileNamed: "SettingsMenu") {
                        
                        SettingsMenu.returnButtonPosX = self.settingsButton.position.x
                        SettingsMenu.returnButtonPosy = self.settingsButton.position.y
                        
                        SettingsMenu.scaleMode = .fill
                        
                        self.view?.presentScene(SettingsMenu, transition: SKTransition.doorway(withDuration: 0.7))
                    }
                })
            }
                
            else if infoButton.contains(pointOfTouch) && !challangeSideBarOpen {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                
                let actionSequence = SKAction.sequence([fadeOut])
                
                SoundManager.playSound(sound: buttonClickAudio)
                
                infoButton.run(actionSequence, completion: {
                    
                    if let InfoMenu = InfoMenu(fileNamed: "InfoMenu") {
                        
                        InfoMenu.returnButtonPosX = self.settingsButton.position.x
                        InfoMenu.returnButtonPosy = self.settingsButton.position.y
                        
                        InfoMenu.scaleMode = .fill
                        
                        self.view?.presentScene(InfoMenu, transition: SKTransition.flipVertical(withDuration: 0.7))
                    }
                })
                
            }
            
            else if buyButton.contains(pointOfTouch) && buyButton.isHidden == false && !challangeSideBarOpen {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                
                let actionSequence = SKAction.sequence([fadeOut])
                
                SoundManager.playSound(sound: buttonClickAudio)
                
                
                
                buyButton.run(actionSequence, completion: {
                    
                    if let BuyMenu = BuyMenu(fileNamed: "BuyMenu") {
                        
                        BuyMenu.returnButtonPosX = self.settingsButton.position.x
                        BuyMenu.returnButtonPosy = self.settingsButton.position.y
                        
                        BuyMenu.scaleMode = .fill
                        
                        self.view?.presentScene(BuyMenu, transition: SKTransition.flipVertical(withDuration: 0.7))
                    }
                })
            }
            
            else if skinsButton.contains(pointOfTouch) && skinsButton.isHidden == false && !challangeSideBarOpen {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                
                let actionSequence = SKAction.sequence([fadeOut])
                
                SoundManager.playSound(sound: buttonClickAudio)
                
                skinsButton.run(actionSequence, completion: {
                    
                    if let SkinMenu = SkinMenu(fileNamed: "SkinMenu") {
                        
                        SkinMenu.returnButtonPosX = self.settingsButton.position.x
                        SkinMenu.returnButtonPosy = self.settingsButton.position.y
                        
                        SkinMenu.scaleMode = .fill
                        
                        self.view?.presentScene(SkinMenu, transition: SKTransition.reveal(with: SKTransitionDirection.up, duration: 0.7))
                    }
                })
            }
            
            else if storyButton.contains(pointOfTouch) && storyButton.isHidden == false && !challangeSideBarOpen {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                
                let actionSequence = SKAction.sequence([fadeOut])
                
                SoundManager.playSound(sound: buttonClickAudio)
                
                storyButton.run(actionSequence, completion: {
                    
                    if let StoryMenu = StoryMenu(fileNamed: "StoryMenu") {
                        
                        StoryMenu.leftCornerButtonPosX = self.settingsButton.position.x
                        StoryMenu.leftCornerButtonPosY = self.settingsButton.position.y
                        StoryMenu.leftCornerButtonImage = "ReturnButton"
                        
                        StoryMenu.rightCornerButtonImage = "NextPageButton"
                        
                        StoryMenu.scaleMode = .fill
                        
                        self.view?.presentScene(StoryMenu, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.7))
                    }
                })
            }
            
            else if challangeSideBar.contains(pointOfTouch) && !challangeSideBarOpen {
                SoundManager.playSound(sound: buttonClickAudio)
                challangeSideBar.position.x = self.frame.size.width * 0.27
                challangeSideBarOpen = true
                for i in challangeProgressIcons {
                    i.isHidden = false
                }
            }
            
            else if challangeSideBarOpen {
                SoundManager.playSound(sound: buttonClickAudio)
                challangeSideBar.position.x = self.frame.size.width * 0.674
                challangeSideBarOpen = false
                for i in challangeProgressIcons {
                    i.isHidden = true
                }
            }
        }
    }
    
    func designLabel() {
        bestScore.zPosition = 2
        bestScore.fontName = "GillSans-UltraBold"
        bestScore.fontSize = 40
        bestScore.fontColor = UIColor(red: 2/255.0, green: 31/255.0, blue: 170/255.0, alpha: 1.0)
        bestScore.position = CGPoint(x: 0, y: (self.frame.size.height - self.frame.size.height * 0.88))
        if let highScore = UserDefaults.standard.value(forKey: "Highscore") as? String {
            bestScore.text = "BEST: \(highScore)"
        }
    }
    
    func designChallangeSideBar() {
        challangeSideBar = SKSpriteNode(imageNamed: "ChallangeSideBar")
        challangeSideBar.zPosition = 3
        challangeSideBar.position = CGPoint(x: (self.frame.size.width * 0.674), y: 0)
    }
    
    func designChallangeProgressIcon(icon: inout SKSpriteNode, position: CGPoint, challangeNumber number: Int) {
        if CloudManager.attemptToRetrieveData(for: "Challange\(number)") != nil || UserDefaults.standard.value(forKey: "Challange\(number)") != nil {
            icon = SKSpriteNode(imageNamed: "GreenTickIcon")
            let userChallangeProgress = UserDefaults.standard
            userChallangeProgress.set("completed", forKey: "Challange\(number)")
            userChallangeProgress.synchronize()
            CloudManager.saveToCloud(data: "completed", dataKey: "Challange\(number)")
        }
        else {
            icon = SKSpriteNode(imageNamed: "ClockIcon")
        }
        icon.position = position
        icon.zPosition = 4
        icon.isHidden = true
        self.addChild(icon)
    }
}
