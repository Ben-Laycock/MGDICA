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
    
    // Sound pools
    var mPooledPopSounds = Array<AVAudioPlayer>()
    var mPooledExplodeSounds = Array<AVAudioPlayer>()
    
    // Saved Data
    var mSaveData = UserDefaults.standard
    
    // Audio enabled
    var mAudioEnabled : Bool = true
    
    
    func Setup()
    {
        // Get saved value for AudioEnabled
        UpdateSettings()
        
        // Get sounds from resources
        let pop1Sound = Bundle.main.path(forResource: "Sounds/pop1", ofType: "mp3")
        let explodeSound = Bundle.main.path(forResource: "Sounds/pop2", ofType: "mp3")
        
        // Create audio objects for sounds pools
        for _ in 1...10
        {
            // Pop1 Sounds
            do
            {
                let audioObject = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: pop1Sound!))
                mPooledPopSounds.append(audioObject)
            }
            catch
            {
                print(error)
            }
            
            // Explode Sounds
            do
            {
                let audioObject = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: explodeSound!))
                mPooledPopSounds.append(audioObject)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    
    func UpdateSettings()
    {
        // Get saved value for AudioEnabled
        mAudioEnabled = mSaveData.bool(forKey: "AudioEnabled")
    }
    
    
    func PlaySound(name soundName: String)
    {
        if !mAudioEnabled { return }
        
        switch soundName
        {
        case "pop1":
            GetNextPopSound().play()
        case "explode":
            GetNextExplodeSound().play()
        default:
            print("No sound was specified!")
        }
        
    }
    
    
    func GetNextPopSound() -> (AVAudioPlayer)
    {
        
        // Look for an inactive audio object
        for aPlayer in mPooledPopSounds
        {
            if !aPlayer.isPlaying
            {
                return aPlayer
            }
        }
        
        // No inactive audio objects were found, create a new one
        let popSound = Bundle.main.path(forResource: "Sounds/pop1", ofType: "mp3")
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: popSound!))
            mPooledPopSounds.append(newAudioPlayer)

            return newAudioPlayer
        } catch {
            print(error)
        }
        
        return mPooledPopSounds[0]
    }
    
    
    func GetNextExplodeSound() -> (AVAudioPlayer)
    {
        // Look for an inactive audio object
        for aPlayer in mPooledExplodeSounds
        {
            if !aPlayer.isPlaying
            {
                return aPlayer
            }
        }
        
        // No inactive audio objects were found, create a new one
        let explodeSound = Bundle.main.path(forResource: "Sounds/pop2", ofType: "mp3")
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: explodeSound!))
            mPooledExplodeSounds.append(newAudioPlayer)

            return newAudioPlayer
        } catch {
            print(error)
        }
        
        return mPooledExplodeSounds[0]
    }
    
}
