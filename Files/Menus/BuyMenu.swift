//
//  BuyMenu.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 04. 22..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class BuyMenu: SKScene {
    
    let buyFullVersionButton = SKSpriteNode(imageNamed: "BuyFullButton")
    var buyFullversionButtonLocked = true
    var fullVersionBought = false
    var isButtonFinalState = false
    static var productReceived = false
    static var transactionEnded = true
    
    let promoTitle = SKSpriteNode(imageNamed: "PromoTitle")
    let promoBackground = SKSpriteNode(imageNamed: "PromoBackgroundPicture")
    let promoPic1 = SKSpriteNode(imageNamed: "PromoPicture1")
    let promoPic2 = SKSpriteNode(imageNamed: "PromoPicture2")
    
    var returnButton = SKSpriteNode()
    var returnButtonPosX: CGFloat?
    var returnButtonPosy: CGFloat?
    
    var buttonClickAudio = SKAudioNode(fileNamed: "ButtonClick.wav")
    
    override func didMove(to view: SKView) {
        
        Service.sharedService.getProduct()
        
        scene?.backgroundColor = .init(red: 191/255, green: 237/255, blue: 1.0, alpha: 1.0)
        
        returnButton = ButtonGenerator.generateButton(imageName: "ReturnButton", scale: 0.1, position: CGPoint(x: returnButtonPosX!, y: returnButtonPosy!))
        
        designPromoPicture(picture: promoPic1, posX: -(self.frame.size.width - self.frame.size.width * 0.75), rotation: 10)
        designPromoPicture(picture: promoPic2, posX: -(self.frame.size.width - self.frame.size.width * 1.25), rotation: -10)
        
        buyFullVersionButton.setScale(0.32)
        buyFullVersionButton.position.y = -(self.frame.size.height - self.frame.size.height * 1.07)
        buyFullVersionButton.alpha = 0.3
        
        promoTitle.setScale(0.95)
        promoTitle.position.y = -(self.frame.size.height - self.frame.size.height * 1.32)
        
        promoBackground.zPosition = -1
        promoBackground.position.y = -(self.frame.size.height - self.frame.size.height * 1.2)
        promoBackground.alpha = 0.6
        
        self.addChild(buyFullVersionButton)
        self.addChild(promoPic1)
        self.addChild(promoPic2)
        self.addChild(returnButton)
        self.addChild(promoTitle)
        self.addChild(promoBackground)
        
        buttonClickAudio.autoplayLooped = false
        buttonClickAudio.name = "button"
        self.addChild(buttonClickAudio)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if BuyMenu.productReceived && buyFullversionButtonLocked {
            buyFullVersionButton.run(SKAction.fadeAlpha(to: 1.0, duration: 0.1))
            buyFullversionButtonLocked = false
        }
        
        if GameViewController.fullVersionEnabled == true && !fullVersionBought {
            fullVersionBought = true
            isButtonFinalState = true
            self.buyFullVersionButton.texture = SKTexture.init(imageNamed: "BoughtButton")
            UserDefaults.standard.setValue("1", forKey: "UserTransaction")
            UserDefaults.standard.synchronize()
            CloudManager.saveToCloud(data: "1", dataKey: "UserTransaction")
            while !CloudManager.savingCompleted {
            }
        }
        if BuyMenu.productReceived && BuyMenu.transactionEnded && !isButtonFinalState {
            buyFullVersionButton.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 1.0, duration: 0.3),
                SKAction.run {self.buyFullVersionButton.texture = SKTexture.init(imageNamed: "BuyFullButton")}
                ]))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let pointOfTouch = touch.previousLocation(in: self)
            
            if returnButton.contains(pointOfTouch) && BuyMenu.transactionEnded {
                
                let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                let actionSequence = SKAction.sequence([fadeOut])
                SoundManager.playSound(sound: buttonClickAudio)
                returnButton.run(actionSequence, completion: {
                    
                    if let scene = MainMenu(fileNamed: "MainMenu") {
                        
                        scene.scaleMode = .fill
                        
                        self.view?.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 0.7))
                    }
                })
            }
            
            else if buyFullVersionButton.contains(pointOfTouch) && !fullVersionBought && BuyMenu.transactionEnded && !buyFullversionButtonLocked {
                
                SoundManager.playSound(sound: buttonClickAudio)
                buyFullVersionButton.run(SKAction.sequence([
                    SKAction.fadeAlpha(to: 0.3, duration: 0.3),
                    SKAction.run {self.buyFullVersionButton.texture = SKTexture.init(imageNamed: "BuyingButton")}
                    ]))
                
                BuyMenu.transactionEnded = false
                Service.sharedService.purchaseProduct()
            }
            
        }
    }
    
    func designPromoPicture(picture: SKSpriteNode, posX: CGFloat, rotation: CGFloat) {
        picture.position.x = posX
        picture.position.y = -(self.frame.size.height - self.frame.size.height * 0.8)
        picture.setScale(0.7)
        picture.zRotation = .pi / rotation
    }
    
}
