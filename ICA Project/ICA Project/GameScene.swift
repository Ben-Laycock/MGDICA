//
//  GameScene.swift
//  ICA Project
//
//  Created by LAYCOCK, BEN (Student) on 05/11/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit

class GameScene: SKScene
{
    var audioPlayer1 = AVAudioPlayer()
    
    override func didMove(to view: SKView)
    {
        
        let sound = Bundle.main.path(forResource: "Sounds/Beep.mp3", ofType: nil)
        
        do
        {
            audioPlayer1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch
        {
            print(error)
        }
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        //let sound = Bundle.main.path(forResource: "Sounds/Beep.mp3", ofType: nil)
        let playSound = SKAction.playSoundFileNamed("Sounds/Beep.mp3", waitForCompletion: true)
        self.run(playSound)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        audioPlayer1.play()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    func printHelloMessage()
    {
        print("Hello Message")
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
        // Code called each frame before rendering
        
        
    }
    
}
