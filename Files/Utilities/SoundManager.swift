//
//  SoundManager.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 04. 27..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import Foundation.NSUserDefaults
import SpriteKit.SKAudioNode

class SoundManager {
    
    static func searchFilename(for audioName: String) -> String {
        switch audioName {
        case "show":
            return "ScoreBoard.wav"
        case "hitB":
            return "PigeonHit.wav"
        case "wing":
            return "PigeonWingFlap.wav"
        case "coo":
            return "PigeonCoo.mp3"
        case "grade":
            return "GradeSound.wav"
        case "ground":
            return "FallGround.wav"
        case "count":
            return "Scoring.wav"
        case "button":
            return "ButtonClick.wav"
        case "hit":
            return "PoopBlindingFace.wav"
        case "throw":
            return "ThrowSound.wav"
        case "lose":
            return "LoseScore.wav"
        case "get":
            return "PoopHit.wav"
        case "poop":
            return "Poop.wav"
        default:
            return String()
        }
    }
    
    static func playSound(sound: SKAudioNode) {
        
        var volumePower: Float = 1.0
        
        if let userVolumePower = UserDefaults.standard.value(forKey: "UserVolumePower") as? String {
            volumePower = Float(userVolumePower)! / 100
        }
        
        if volumePower != 0 {
            if let soundState = UserDefaults.standard.value(forKey: sound.name!) as? String {
                if soundState.last! == "1" && volumePower != 0 {
                    if #available(iOS 10.0, *) {
                        sound.run(SKAction.sequence([
                            SKAction.changeVolume(to: volumePower, duration: 0),
                            SKAction.play()
                            ]))
                    } else {
                        sound.run(SKAction.sequence([
                            SKAction.changeVolume(to: volumePower, duration: 0),
                            SKAction.playSoundFileNamed(SoundManager.searchFilename(for: sound.name!), waitForCompletion: true)
                            ]))
                    }
                }
            }
            else {
                if #available(iOS 10.0, *) {
                    sound.run(SKAction.sequence([
                        SKAction.changeVolume(to: volumePower, duration: 0),
                        SKAction.play()
                        ]))
                } else {
                    sound.run(SKAction.sequence([
                        SKAction.changeVolume(to: volumePower, duration: 0),
                        SKAction.playSoundFileNamed(SoundManager.searchFilename(for: sound.name!), waitForCompletion: true)
                        ]))
                }
            }
        }
    }
}
