//
//  FinalScoreBoard.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 03. 05..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class FinalScoreBoard {
    
    static var scoreColor: SKColor?
    static var userHighscore: String?
    static var scoreAnimationSleepCounter: UInt32 = 25000
    var scoreCounters: [SKLabelNode] = []
    let finalScoreBoard = SKSpriteNode(imageNamed: "FinalScore")
    let userHighScore = UserDefaults.standard
    
    init(scene: SKScene) {
        finalScoreBoard.setScale(1.4)
        finalScoreBoard.position = CGPoint(x: 0, y: scene.frame.size.height * 0.7)
    }
    
    func createFinalScoreBoard(in scene: SKScene) {
        
        var initialYPosition = CGFloat(0.01)
        
        for i in 1...2 {
            
            let boardScore = SKLabelNode()
            if i == 2, let _ = userHighScore.value(forKey: "Highscore") {
                boardScore.text = userHighScore.value(forKey: "Highscore") as? String
            } else {
                boardScore.text = "0"
            }
            boardScore.fontColor = .black
            boardScore.position = CGPoint(x: scene.frame.size.width * -0.19, y: finalScoreBoard.position.y * initialYPosition)
            boardScore.fontSize = 38
            boardScore.fontName = "American Typewriter Bold"
            boardScore.zPosition = 2
            finalScoreBoard.addChild(boardScore)
            
            initialYPosition = -0.097
        }
        
        scene.addChild(finalScoreBoard)
    }
    
    func playScoreBoardAnimation(in scene: SKScene) {
        finalScoreBoard.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.25),
            SKAction.run { SoundManager.playSound(sound: GameScene.audios[0]) },
            SKAction.move(to: CGPoint(x: 0, y: scene.frame.size.height * 0.30), duration: 0.4),
            SKAction.move(to: CGPoint(x: 0, y: scene.frame.size.height * 0.35), duration: 0.1),
            SKAction.run {
                if (FinalScoreBoard.userHighscore != "0") {
                    if (self.finalScoreBoard.children[1] as! SKLabelNode).text! == "0" {
                        for i in 0...1 {
                            self.animateSubScore(subScore: self.finalScoreBoard.children[i])
                        }
                    }
                    else {
                        self.animateSubScore(subScore: self.finalScoreBoard.children[0])
                        FinalScoreBoard.scoreAnimationSleepCounter = 50000
                        FinalScoreBoard.scoreColor = .red
                    }
                }
                else {
                    usleep(150000)
                    self.gradeUserScore(userScore: self.finalScoreBoard.children[0] as! SKLabelNode, scene: scene)
                    (scene as! GameScene).showFinalScene()
                }
            }
            ]))
        
        if let newUserHighScore = FinalScoreBoard.userHighscore {
            if Int(newUserHighScore)! > Int((self.finalScoreBoard.children[1] as! SKLabelNode).text!)! {
                let userHighScore = UserDefaults.standard
                userHighScore.set(newUserHighScore, forKey: "Highscore")
                userHighScore.synchronize()
                CloudManager.saveToCloud(data: newUserHighScore, dataKey: "Highscore")
            }
        }
    }
    
    func animateSubScore(subScore: SKNode) {
        subScore.run(SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.2),
            SKAction.scale(to: 1, duration: 0.2),
            SKAction.run {
                self.scoreCounters.append(subScore as! SKLabelNode)
                self.scoreCounters.last?.text = "0"
                self.scoreCounters.last?.fontColor = FinalScoreBoard.scoreColor
                GameScene.scoreAnimationPlayed = false
            }
        ]))
    }
    
    func gradeUserScore(userScore: SKLabelNode, scene: SKScene) {
        
        var gradeImage: String
        var imagePosition = CGPoint()
        
        switch Int(userScore.text!)! {
        case ..<35:
            gradeImage = "Noob Grade"
            imagePosition = CGPoint(x: scene.frame.size.width * 0.25, y: finalScoreBoard.position.y * 0.88)
        case 35..<100:
            gradeImage = "Average Joe Grade"
            imagePosition = CGPoint(x: scene.frame.size.width * 0.23, y: finalScoreBoard.position.y * 0.92)
        default:
            gradeImage = "Pro Grade"
            imagePosition = CGPoint(x: scene.frame.size.width * 0.23, y: finalScoreBoard.position.y * 0.92)
        }
        
        let grade = SKSpriteNode(imageNamed: gradeImage)
        grade.position = imagePosition
        grade.setScale(30)
        grade.zPosition = 3
        SoundManager.playSound(sound: GameScene.audios[4])
        grade.run(SKAction.sequence([
            SKAction.scale(to: 1.4, duration: 0.3)
            ]))
        scene.addChild(grade)
        
    }
}
