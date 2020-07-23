//
//  ScoreBoard.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 03. 05..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode

class ScoreBoard: SKLabelNode {
    
    init(withFontName fontName: String?, withFontSize fontSize: CGFloat, withZPosition zPosition: CGFloat, withPosition position: CGPoint) {
        super.init()
        super.fontName = fontName
        super.fontSize = fontSize
        super.zPosition = zPosition
        super.position = position
        super.text = "0"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var isScoreCalculating = false
    var playerScore = 0 {
        didSet {
            ScoreBoard.isScoreCalculating = true
            if oldValue > playerScore {
                setPlayerScore(to: playerScore, scoreDecreased: true)
            }
            else {
                setPlayerScore(to: playerScore, scoreDecreased: false)
            }
        }
    }
    
    func setPlayerScore(to score: Int, scoreDecreased: Bool) {
        self.text = "\(playerScore)"
        if scoreDecreased {
            self.fontColor = SKColor.red
            if !GameScene.didPlayerLostPoint {
                GameScene.didPlayerLostPoint = true
            }
        }
        else {
            self.fontColor = SKColor.green
        }
        GameScene.scoreBoardAnimationSleepCounter = 0
        ScoreBoard.isScoreCalculating = false
    }
}
