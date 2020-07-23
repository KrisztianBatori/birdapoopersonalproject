//
//  BackgroundSongManager.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 04. 16..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import AVFoundation.AVFAudio

class SongManager {
    
    static let shared = SongManager()
    
    var audioPlayer = AVAudioPlayer()
    
    private init() { }
    
    func setup() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "BackgroundSong", ofType: "wav")!))
            audioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func play() {
        try? AVAudioSession.sharedInstance().setActive(true)
        
        if let volumePower = UserDefaults.standard.value(forKey: "UserVolumePower") as? String {
            audioPlayer.volume = Float(volumePower)! / 100
        }
        else {
            audioPlayer.volume = 1.0
        }
        
        if let soundState = UserDefaults.standard.value(forKey: "background") as? String {
            if soundState.last! == "1" {
                audioPlayer.play() 
                audioPlayer.numberOfLoops = -1
            }
        }
        else if !GameViewController.fullVersionEnabled || GameViewController.fullVersionEnabled {
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        }
    }
    
    func stop() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.prepareToPlay()
    }
    
    func adjustVolume(volume: Float) {
        audioPlayer.volume = volume
    }
}
