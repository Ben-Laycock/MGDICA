//
//  AudioSystem.swift
//  ICA Project
//
//  Created by Ben on 08/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation

class AudioSystem
{

    // Sounds
    var pop1 : SKAction!
    var explode : SKAction!
    var buttonClick : SKAction!
    var toggle : SKAction!
    var heal : SKAction!
    var confirm : SKAction!
    
    // Saved Data
    var mSaveData = UserDefaults.standard
    
    // Audio enabled
    var mAudioEnabled : Bool = true
    
    
    func Setup()
    {
        // Get saved value for AudioEnabled
        UpdateSettings()
        
        // Sounds
        pop1 = SKAction.playSoundFileNamed("Sounds/Pop1.mp3", waitForCompletion: true)
        explode = SKAction.playSoundFileNamed("Sounds/Explosion.wav", waitForCompletion: true)
        buttonClick = SKAction.playSoundFileNamed("Sounds/ButtonClick.wav", waitForCompletion: true)
        toggle = SKAction.playSoundFileNamed("Sounds/Toggle.wav", waitForCompletion: true)
        heal = SKAction.playSoundFileNamed("Sounds/Heal.wav", waitForCompletion: true)
        confirm = SKAction.playSoundFileNamed("Sounds/Confirm.wav", waitForCompletion: true)
    }
    
    
    func UpdateSettings()
    {
        // Get saved value for AudioEnabled
        mAudioEnabled = mSaveData.bool(forKey: "AudioEnabled")
    }
    
    
    func PlaySound(name soundName: String, from scene: SKScene)
    {
        if !mAudioEnabled { return }
        
        switch soundName
        {
        case "pop1":
            scene.run(pop1)
        case "explode":
            scene.run(explode)
        case "click":
        scene.run(buttonClick)
        case "toggle":
            scene.run(toggle)
        case "heal":
            scene.run(heal)
        case "confirm":
            scene.run(confirm)
        default:
            print("No sound was specified!")
        }
        
    }
    
}
