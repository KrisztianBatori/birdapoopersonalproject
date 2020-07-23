//
//  GameScene.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 03..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate {
     
     static let audios: [SKAudioNode] = [
          
     SKAudioNode(fileNamed: "ScoreBoard.wav"),         // audios[0]
     SKAudioNode(fileNamed: "PigeonHit.wav"),          // audios[1]
     SKAudioNode(fileNamed: "PigeonWingFlap.wav"),     // audios[2]
     SKAudioNode(fileNamed: "PigeonCoo.mp3"),          // audios[3]
     SKAudioNode(fileNamed: "GradeSound.wav"),         // audios[4]
     SKAudioNode(fileNamed: "FallGround.wav"),         // audios[5]
     SKAudioNode(fileNamed: "Scoring.wav"),            // audios[6]
     SKAudioNode(fileNamed: "ButtonClick.wav"),        // audios[7]
     SKAudioNode(fileNamed: "PoopBlindingFace.wav"),   // audios[8]
     SKAudioNode(fileNamed: "ThrowSound.wav"),         // audios[9]
     SKAudioNode(fileNamed: "LoseScore.wav"),          // audios[10]
     SKAudioNode(fileNamed: "PoopHit.wav"),            // audios[11]
     SKAudioNode(fileNamed: "OpeningSound.mp3"),       // audios[12]
     SKAudioNode(fileNamed: "Poop.wav")                // audios[13]
          
     ]
     
     var poop_o_meter: MovableObject? = nil
     var birdSkinPrefix = UserDefaults.standard.value(forKey: "BirdSkin") as? String ?? CloudManager.attemptToRetrieveData(for: "BirdSkin") ?? String()
     var bird: MovableObject? = nil
     var manArray: [MovableObject]? = []
     var contactedManIndex: Int?
     
     var manSpawningTimer = 0
     var manSpawnTime = 0
     var attackManSpawnTime = Int.random(in: 3...7)
     
     var scoreBoard: ScoreBoard? = nil
     var finalScoreBoard: FinalScoreBoard?
     var isFinalScoreDisplayed = false
     var gradeAnimationSleepCounter = 0
     var highScoreSurpassed = false
     var scoreAnimationStopped = false
     var scoreSoundPlayed = true
     static var scoreAnimationPlayed = true
     static var scoreBoardAnimationSleepCounter = 40
     
     var scoreAnimationDirector = 1
     var gameOver = false
     var screenFreezed = false
     var isGameOver: Bool? {
          didSet {
               if isGameOver! == true {
                    if !GameViewController.fullVersionEnabled {
                         GameViewController.bannerView.isHidden = false
                         let bannerRequest = GADRequest()
                         if !GameViewController.isPersonalizedAdsAllowed {
                              let extras = GADExtras()
                              extras.additionalParameters = ["npa": "1"]
                              bannerRequest.register(extras)
                         }
                         bannerRequest.testDevices = ["XXX", "XXX"]
                         GameViewController.bannerView.load(bannerRequest)
                    }
                    attackingMan.throwAt(in: self, bird: bird as! Bird)
               }
               else {
                    attackingMan.missThrow(in: self, bird: bird as! Bird)
               }
          }
     }
     
     var replayButton = SKSpriteNode()
     var mainMenuButton = SKSpriteNode()
     var finalAnimationPlayed = true
     var finalButtonsShown = false
     
     let tutorialNode = SKSpriteNode(imageNamed: "Tutorial")
     var tutorialEnabled = false
     var tutorialEnded = true
     var tutorialShown = false
     
     var challangeOneCompleted = true
     var challangeTwoCompleted = true
     var challangeThreeCompleted = true
     static var didPlayerLostPoint = false
     
     let challangeNode = SKSpriteNode(imageNamed: "ChallangeCompletedNode1")
     var challangeNodeAnimationStarted = false
     var challangeNodeTextureSuffix = 1
     var challangeNodeAnimationCounter = 0
     
     let reviewService = ReviewService.shared
     
     override func didMove(to view: SKView) {
          
          
          /*****************************************\
           
                      LOAD PHYSICS WORLD
           
          \*****************************************/
          
          self.physicsWorld.contactDelegate = self
          self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
          
          
          /*****************************************\
           
                      LOAD USER SETTINGS
           
           \*****************************************/
          
          
          if let fpsState = UserDefaults.standard.value(forKey: "FPSState") as? String {
               if fpsState.last! == "1" {
                    view.showsFPS = true
               }
          }
          else if let fpsState = CloudManager.attemptToRetrieveData(for: "FPSState") {
               if fpsState.last! == "1" {
                    view.showsFPS = true
               }
          }
          
          if let tutorialState = UserDefaults.standard.value(forKey: "TutorialState") as? String {
               if tutorialState.last! == "1" {
                    tutorialEnabled = true
                    tutorialEnded = false
               }
               else {
                    tutorialEnded = true
               }
          }
          else if let tutorialState = CloudManager.attemptToRetrieveData(for: "TutorialState") {
               if tutorialState.last! == "1" {
                    tutorialEnabled = true
                    tutorialEnded = false
               }
               else {
                    tutorialEnded = true
               }
          }
          else {
               tutorialEnabled = true
               tutorialEnded = false
          }
          
          /*****************************************\
           
                         LOAD AUDIOS
           
           \*****************************************/
          
          
          for audio in GameScene.audios {
               audio.autoplayLooped = false
               self.addChild(audio)
          }
          
          GameScene.audios[0].name = "show"
          GameScene.audios[1].name = "hitB"
          GameScene.audios[2].name = "wing"
          GameScene.audios[3].name = "coo"
          GameScene.audios[4].name = "grade"
          GameScene.audios[5].name = "ground"
          GameScene.audios[6].name = "count"
          GameScene.audios[7].name = "button"
          GameScene.audios[8].name = "hit"
          GameScene.audios[9].name = "throw"
          GameScene.audios[10].name = "lose"
          GameScene.audios[11].name = "get"
          GameScene.audios[12].name = "start"
          GameScene.audios[13].name = "poop"
          
          /**********************************************************\
           
             LOAD BACKGROUND, POOP-O-METER, BIRD, AND THE SCOREBOARD
           
          \**********************************************************/
          
          Background.createBackGround(BackgroundImage: "Background", forScene: self)
          
          poop_o_meter = Poop_o_Meter(imageNamed: "PS1",
                      scalingTo: 0.5,
                      withPosition: CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.4),
                      withPhysicsOf: nil,
                      addMovement: nil)
          
          bird = Bird(imageNamed: "\(birdSkinPrefix)Bird1",
                      scalingTo: 0.35,
                      withPosition: CGPoint(x: self.frame.size.width / -5, y: self.frame.size.height / 6),
                      withPhysicsOf: nil,
                      addMovement: nil)
          (bird as! Bird).birdSkinPrefix = birdSkinPrefix
          
          scoreBoard = ScoreBoard(withFontName: "AvenirNext-Bold",
                                  withFontSize: 96,
                                  withZPosition: 1,
                                  withPosition: CGPoint(x: self.frame.size.width * -0.35, y: self.frame.size.height * 0.4))
          
          self.addChild(bird!)
          self.addChild(poop_o_meter!)
          self.addChild(scoreBoard!)
          
          
          spawnManIfCan(duration: 0) /* At the start of the game, a man is needed to be spawn in order to
                                        prevent a bug. */
          
          
          /**********************************************************\
           
                                LOAD CHALLANGES
           
           \**********************************************************/
          
          
          if CloudManager.attemptToRetrieveData(for: "Challange1") == nil && UserDefaults.standard.value(forKey: "Challange1") == nil {
               challangeOneCompleted = false
          }
          if CloudManager.attemptToRetrieveData(for: "Challange2") == nil && UserDefaults.standard.value(forKey: "Challange2") == nil {
               challangeTwoCompleted = false
          }
          if CloudManager.attemptToRetrieveData(for: "Challange3") == nil && UserDefaults.standard.value(forKey: "Challange3") == nil {
               challangeThreeCompleted = false
          }
     }
     
     override func update(_ currentTime: TimeInterval) {
          
          if !gameOver {
               
               // The gameplay
               
               Background.mutateBackground(ofScene: self)
               
               if GameScene.scoreBoardAnimationSleepCounter == 40 {
                    scoreBoard!.fontColor = .blue
               }
               else {
                    GameScene.scoreBoardAnimationSleepCounter += 1
               }
               
               animateObjectIfCan(object: poop_o_meter!, hasDirection: true)
               animateObjectIfCan(object: bird!)
               
               if tutorialEnabled && !tutorialShown {
                    tutorialEnabled = false
                    showTutorial()
               }
               else if tutorialEnded {
                    (poop_o_meter as! Poop_o_Meter).incrementEventCounter()
                    spawnManIfCan()
                    if let manIndex = contactedManIndex {
                         if let manAnimationPhase = manArray?[manIndex].animationPhase {
                              if (manAnimationPhase > 0) {
                                   animateObjectIfCan(object: manArray![contactedManIndex!], hasDirection: false, isMan: true)
                              }
                         }
                    }
               }
          }
          else {
               
               // Mostly animations and saving the user's score
               
               animateChallangeNodeIfCan()
               
               if !finalAnimationPlayed {
                    showFinalScene()
                    finalAnimationPlayed = true
               }
               if !screenFreezed {
                    freezeScreen()
               }
               if !(bird as! Bird).birdFallingAnimationDone {
                    (bird as! Bird).fallToGround()
               }
               if !isFinalScoreDisplayed {
                    finalScoreBoard = FinalScoreBoard(scene: self)
                    finalScoreBoard?.createFinalScoreBoard(in: self)
                    finalScoreBoard?.playScoreBoardAnimation(in: self)
                    isFinalScoreDisplayed = true
               }
               if !GameScene.scoreAnimationPlayed {
                    
                    for i in 0..<(finalScoreBoard?.scoreCounters.count)! {
                         if highScoreSurpassed {
                              finalScoreBoard!.scoreCounters[0].fontColor = .green
                              finalScoreBoard!.scoreCounters[1].fontColor = .green
                              highScoreSurpassed = false
                              gradeAnimationSleepCounter -= 1
                         }
                         if !scoreAnimationStopped {
                              finalScoreBoard?.scoreCounters[i].text = String(scoreAnimationDirector + Int(finalScoreBoard!.scoreCounters[i].text!)!)
                              SoundManager.playSound(sound: GameScene.audios[6])
                         }
                         usleep(FinalScoreBoard.scoreAnimationSleepCounter)
                         if i == 0 {
                              if let _ = finalScoreBoard!.userHighScore.value(forKey: "Highscore") as? String {
                                   if finalScoreBoard!.scoreCounters[0].text! == (finalScoreBoard?.finalScoreBoard.children[1] as! SKLabelNode).text! {
                                        if finalScoreBoard!.scoreCounters[0].fontColor != .green {
                                             finalScoreBoard!.scoreCounters[0].fontColor = .black
                                        }
                                        finalScoreBoard?.scoreCounters.append(finalScoreBoard?.finalScoreBoard.children[1] as! SKLabelNode)
                                        if finalScoreBoard!.scoreCounters[0].fontColor != .green {
                                             finalScoreBoard!.scoreCounters[1].fontColor = .black
                                        }
                                        else {
                                             finalScoreBoard!.scoreCounters[1].fontColor = .green
                                             gradeAnimationSleepCounter += 1
                                        }
                                        FinalScoreBoard.scoreAnimationSleepCounter = 25000
                                        highScoreSurpassed = true
                                   }
                              }
                         }
                         if Int(scoreBoard!.text!) == Int(finalScoreBoard!.scoreCounters[i].text!) {
                              GameScene.scoreAnimationPlayed = true
                              gradeAnimationSleepCounter += 1
                         }
                    }
               }
               if gradeAnimationSleepCounter == 3 {
                    GameScene.audios[6].run(SKAction.stop())
                    usleep(150000)
                    finalScoreBoard?.gradeUserScore(userScore: finalScoreBoard!.finalScoreBoard.children[0] as! SKLabelNode, scene: self)
                    gradeAnimationSleepCounter += 1
                    finalAnimationPlayed = false
               }
               else if gradeAnimationSleepCounter == 1 || gradeAnimationSleepCounter == 2 {
                    gradeAnimationSleepCounter += 1
               }
          }
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          if !gameOver {
               
               // Beginning the game / controlling the bird during gameplay.
               
               if tutorialShown && !tutorialEnded {
                    tutorialEnded = true
                    tutorialNode.removeFromParent()
               }
               else if tutorialEnded {
                    if (children.filter() {$0.name == "Poop"}).count == 0 {
                         if (bird?.animationPhase == 1) {
                              bird?.animateObject(newAnimationPhase: 4)
                         }
                         else {
                              bird?.animateObject(newAnimationPhase: 3)
                         }
                         self.addChild((bird as! Bird).poopWithBird(in: self, with: (poop_o_meter as! Poop_o_Meter).getPoopSpeed(), affected: scoreBoard!, with: (birdSkinPrefix == "Edgy" ? "Pro Poop" : "Poop")))
                         SoundManager.playSound(sound: GameScene.audios[13])
                    }
               }
          } else {
               
               if !GameScene.scoreAnimationPlayed {
                    
                    // Stopping the counting animation.
                    
                    finalScoreBoard!.scoreCounters[0].text = scoreBoard!.text
                    if finalScoreBoard?.scoreCounters.count != 1 {
                         if finalScoreBoard!.scoreCounters[0].text == finalScoreBoard!.scoreCounters[1].text {
                              finalScoreBoard!.scoreCounters[0].color = .black
                              finalScoreBoard?.scoreCounters[1].text = scoreBoard!.text
                         }
                         else if Int(finalScoreBoard!.scoreCounters[0].text!)! > Int((finalScoreBoard!.scoreCounters[1].text)!)! {
                              finalScoreBoard!.scoreCounters[0].color = .green
                              finalScoreBoard!.scoreCounters[1].color = .green
                              finalScoreBoard?.scoreCounters[1].text = scoreBoard!.text
                         }
                         else if Int(finalScoreBoard!.scoreCounters[1].text!)! <= 0 {
                              finalScoreBoard?.scoreCounters[1].text = scoreBoard!.text
                         }
                    }
                    else if Int(finalScoreBoard!.scoreCounters[0].text!)! > Int((finalScoreBoard?.finalScoreBoard.children[1] as! SKLabelNode).text!)! {
                         finalScoreBoard!.scoreCounters[0].fontColor = .green
                         (finalScoreBoard?.finalScoreBoard.children[1] as! SKLabelNode).text! = finalScoreBoard!.scoreCounters[0].text!
                         (finalScoreBoard?.finalScoreBoard.children[1] as! SKLabelNode).color = .green
                    }
                    scoreAnimationStopped = true
               }
               
               if finalButtonsShown {
                    
                    // Quitting or starting a new game.
                    
                    for touch in touches {
                         
                         let pointOfTouch = touch.previousLocation(in: self)
                         let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
                         let actionSequence = SKAction.sequence([fadeOut])
                         
                         if replayButton.contains(pointOfTouch) {
                              
                              GameScene.didPlayerLostPoint = false
                              if GameViewController.fullVersionEnabled == false {
                                   GameViewController.bannerView.isHidden = true
                              }
                              
                              SceneTransitionSongManager.shared.play()
                              replayButton.run(actionSequence, completion: {
                                   
                                   for audio in GameScene.audios {
                                        audio.removeFromParent()
                                   }
                                   
                                   if let GameScene = GameScene(fileNamed: "GameScene") {
                                        Poop_o_Meter.animationDirector = 1
                                        Man.didGetPooped = true
                                        
                                        GameScene.scaleMode = .fill
                                        
                                        self.view?.presentScene(GameScene, transition: SKTransition.fade(withDuration: 0.8))
                                   }
                              })
                         }
                         if mainMenuButton.contains(pointOfTouch) {
                              
                              GameScene.didPlayerLostPoint = false
                              SoundManager.playSound(sound: GameScene.audios[7])
                              
                              view?.showsFPS = false
                              if GameViewController.fullVersionEnabled == false {
                                   GameViewController.bannerView.isHidden = true
                              }
                              
                              mainMenuButton.run(actionSequence, completion: {
                                   
                                   for audio in GameScene.audios {
                                        audio.removeFromParent()
                                   }
                                   
                                   if let scene = MainMenu(fileNamed: "MainMenu") {
                                        
                                        Poop_o_Meter.animationDirector = 1
                                        Man.didGetPooped = true
                                        
                                        scene.scaleMode = .fill
                                        
                                        self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.8))
                                   }
                              })
                         }
                    }
               }
          }
     }
     
     func didBegin(_ contact: SKPhysicsContact) {
          
          // Collision handlings.
          
          if (contact.bodyB.categoryBitMask == Physics.PhysicsCategories.Man.rawValue && contact.bodyA.categoryBitMask == Physics.PhysicsCategories.Poop.rawValue) {
               
               var hitSound = "PoopHit.wav"
               
               contactedManIndex = manArray!.firstIndex(of: contact.bodyB.node as! MovableObject)
               
               let man = manArray![contactedManIndex!] as! Man
               
               if man.manAttacking {
                    man.blindAttackingMan()
                    hitSound = "PoopBlindingFace.wav"
               }
               else {
                    if contact.bodyA.node == attackingMan.assignedPoop {
                         man.blindMan()
                    }
                    man.animationPhase = 1
               }
               while !ScoreBoard.isScoreCalculating {
                    scoreBoard!.playerScore += 1
                    break
               }
               contact.bodyA.node?.removeFromParent()
               man.setGetPooped()
               SoundManager.playSound(sound: hitSound == "PoopHit.wav" ? GameScene.audios[11] : GameScene.audios[8])
          }
     }
     
     func spawnManIfCan(duration: Int = 6) {
          if (manSpawningTimer == manSpawnTime) {
               
               let manDesignPattern = Int.random(in: 1...3)
               var manImageName: String
               var isAttackingMan = false
               var manMovement = [
                    SKAction.move(to: CGPoint(x: -self.frame.size.width * 0.6, y: -(bird!.position.y * 2.1)), duration: TimeInterval(duration)),
                    SKAction.run {
                         Man.determinePlayerScore(scoreBoard: self.scoreBoard!);
                         if Man.didGetPooped == false {
                              GameScene.audios[10].run(SKAction.stop())
                              SoundManager.playSound(sound: GameScene.audios[10])
                         };
                         Man.didGetPooped = false
                    },
                    SKAction.removeFromParent()
               ]
               
               if (attackManSpawnTime == 0) {
                    attackManSpawnTime = Int.random(in: 3...7)
                    manImageName = "AM\(manDesignPattern)S1"
                    Man.manCirclePosX = -0.05
                    isAttackingMan = true
                    manMovement = [
                         SKAction.move(to: CGPoint(x: -self.frame.size.width * 0.3, y: -(bird!.position.y * 2.1)), duration: TimeInterval(4.5)),
                         SKAction.run { self.triggerManAttack() },
                         SKAction.move(to: CGPoint(x: -self.frame.size.width * 0.6, y: -(bird!.position.y * 2.1)), duration: TimeInterval(1.5)),
                         SKAction.removeFromParent()
                    ]
               }
               else {
                    attackManSpawnTime -= 1
                    manImageName = "M\(manDesignPattern)S0"
                    Man.manCirclePosX = 0.02
               }
               
               let man = Man(imageNamed: manImageName,
                         scalingTo: 0.4,
                         withPosition: CGPoint(x: self.frame.size.width * 0.70, y: -(bird!.position.y * 2.1)),
                         withPhysicsOf: .Man,
                         addMovement: SKAction.sequence(manMovement))
               man.setDesignPattern(to: manDesignPattern)
               man.manImageName = manImageName
               man.manAttacking = isAttackingMan
               if isAttackingMan {
                    attackingMan.man = man
                    attackingMan.assignPoopToAttackingMan(in: self, aimingAt: bird as! Bird)
               }
               manArray?.append(man)
               self.addChild(man)
               manSpawningTimer = 0
               manSpawnTime = Int.random(in: 100...135)
          }
          else {
               manSpawningTimer += 1
          }
     }
     
     func triggerManAttack() {
          contactedManIndex = manArray!.firstIndex(of: attackingMan.man!)
          
          let man = manArray![contactedManIndex!] as! Man
          man.animationPhase = 1
     }
     
     func freezeScreen() {
          
          // For animations.
          
          for case let child as SKSpriteNode in self.children {
               child.removeAllActions()
               if child.name!.contains("Poop") {
                    child.removeFromParent()
               }
          }
          screenFreezed = true
          var textureChanger = 4
          if bird?.animationPhase == 3 {
               textureChanger = 3
          }
          if bird?.animationPhase == 4 {
               textureChanger = 1
          }
          bird?.texture = SKTexture(imageNamed: "\(birdSkinPrefix)Bird\((bird?.animationPhase)! + textureChanger)")
          bird?.zPosition = 2
          scoreBoard?.removeFromParent()
          poop_o_meter?.removeFromParent()
          if scoreBoard?.text?.first == "-" {
               if !challangeOneCompleted {
                    if Int((scoreBoard?.text)!)! <= -150 {
                         UserDefaults.standard.setValue("completed", forKey: "Challange1")
                         UserDefaults.standard.synchronize()
                         CloudManager.saveToCloud(data: "completed", dataKey: "Challange1")
                         animateGreenTick(titleText: "CHALLANGE 1")
                    }
               }
               scoreAnimationDirector = -1
               FinalScoreBoard.userHighscore = scoreBoard?.text
               FinalScoreBoard.scoreColor = .red
          }
          else {
               if Int((scoreBoard?.text)!)! >= 35 && !GameScene.didPlayerLostPoint && !challangeThreeCompleted {
                    UserDefaults.standard.setValue("completed", forKey: "Challange3")
                    UserDefaults.standard.synchronize()
                    CloudManager.saveToCloud(data: "completed", dataKey: "Challange3")
                    (scene as? GameScene)?.animateGreenTick(titleText: "CHALLANGE 3")
               }
               if Int((scoreBoard?.text)!)! >= 100 && !challangeTwoCompleted {
                    UserDefaults.standard.setValue("completed", forKey: "Challange2")
                    UserDefaults.standard.synchronize()
                    CloudManager.saveToCloud(data: "completed", dataKey: "Challange2")
                    (scene as? GameScene)?.animateGreenTick(titleText: "CHALLANGE 2")
               }
               FinalScoreBoard.userHighscore = scoreBoard?.text
               FinalScoreBoard.scoreColor = .green
          }
     }
     
     func animateObjectIfCan(object: MovableObject, hasDirection: Bool = false, isMan: Bool = false) {
          if (object.canAnimateObject(SleepCounter: object.animationSleepCounter!)) {
               object.animationSleepCounter = 0
               object.animateObject(newAnimationPhase: object.animationPhase! + (hasDirection ? Poop_o_Meter.animationDirector : 0))
               if isMan {
                    object.animationPhase! += 1
               }
          }
          else {
               object.animationSleepCounter! += 1
          }
     }
     
     func showFinalScene() {
          GameViewController.requestReviewCounter += 1
          if GameViewController.requestReviewCounter == 6 {
               GameViewController.requestReviewCounter = 0
               self.run(SKAction.run {
                    let deadline = DispatchTime.now() + .milliseconds(80)
                    DispatchQueue.main.asyncAfter(deadline: deadline, execute: {[weak self] in
                         let reviewRequested = self?.reviewService.requestReview() ?? false
                         self?.showFinalButtons(reviewWaitTime: reviewRequested)
                         })
               })
          }
          else {
               showFinalButtons(reviewWaitTime: false)
          }
     }
     
     func showTutorial() {
          tutorialNode.setScale(0.77)
          tutorialNode.position = CGPoint(x: 0, y: 0)
          tutorialNode.zPosition = 2
          tutorialNode.alpha = 0
          
          self.addChild(tutorialNode)
          
          tutorialNode.run(SKAction.sequence([
               SKAction.wait(forDuration: 0.25),
               SKAction.fadeIn(withDuration: 0.5),
               SKAction.run({self.tutorialShown = true})
               ]))
     }
     
     func animateGreenTick(titleText: String) {
          
          // Minor animation.
          
          challangeNode.position = CGPoint(x: -(self.frame.size.width * 1.1), y: 0)
          challangeNode.setScale(1.3)
          challangeNode.zPosition = 3
          self.addChild(challangeNode)
          
          let title = SKLabelNode()
          title.text = titleText
          title.position = CGPoint(x: -(self.frame.size.width * 1.19), y: challangeNode.frame.size.height * -0.05)
          title.fontName = "AmericanTypewriter-CondensedBold"
          title.fontSize = 55
          title.fontColor = .blue
          title.zPosition = 5
          self.addChild(title)
          
          title.run(SKAction.sequence([
               SKAction.move(to: CGPoint(x: -(self.frame.size.width * 0.09), y: challangeNode.frame.size.height * -0.05), duration: 0.7),
               SKAction.wait(forDuration: 1),
               SKAction.move(to: CGPoint(x: self.frame.size.width * 1.19, y: challangeNode.frame.size.height * -0.05), duration: 0.7),
               ]))
          
          challangeNode.run(
               SKAction.sequence([
                    SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.7),
                    SKAction.run {
                         self.challangeNodeAnimationStarted = true
                    },
                    SKAction.wait(forDuration: 1),
                    SKAction.move(to: CGPoint(x: self.frame.size.width * 1.1, y: 0), duration: 0.7)
                    ])
          )
     }
     
     func animateChallangeNodeIfCan() {
          if challangeNodeAnimationStarted {
               challangeNodeAnimationCounter += 1
               if challangeNodeAnimationCounter == 2 {
                    challangeNodeAnimationCounter = 0
                    challangeNodeTextureSuffix += 1
                    if challangeNodeTextureSuffix != 13 {
                         challangeNode.texture = SKTexture(imageNamed: "ChallangeCompletedNode\(challangeNodeTextureSuffix)")
                    }
                    else {
                         challangeNodeAnimationStarted = false
                    }
               }
          }
     }
     
     func showFinalButtons(reviewWaitTime: Bool) {
          let waitTime = reviewWaitTime ? 1.35 : 0.35
          replayButton = ButtonGenerator.generateButton(imageName: "TryAgainButton", scale: 0.9, position: CGPoint(x: self.frame.size.width * -0.225, y: self.frame.size.height / 10))
          mainMenuButton = ButtonGenerator.generateButton(imageName: "MainMenuButton", scale: 0.9, position: CGPoint(x: self.frame.size.width * 0.225, y: self.frame.size.height / 10))
          replayButton.alpha = 0
          mainMenuButton.alpha = 0
          self.addChild(replayButton)
          self.addChild(mainMenuButton)
          replayButton.run(SKAction.sequence([
               SKAction.wait(forDuration: waitTime),
               SKAction.fadeIn(withDuration: 0.6)
               ]))
          mainMenuButton.run(SKAction.sequence([
               SKAction.wait(forDuration: waitTime),
               SKAction.fadeIn(withDuration: 0.6),
               SKAction.run {
                    self.finalButtonsShown = true
               }
               ]))
     }
}
