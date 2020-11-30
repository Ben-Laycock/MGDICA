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
import CoreMotion


class GameScene: SKScene
{
    
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    let virusTexture = SKTexture(imageNamed: "Virus")
    var textureSize = CGSize.zero
    
    let numOfViruses = 50
    
    var activeViruses = Set<Virus>()
    var inactiveViruses = Set<Virus>()
    
    var audioPlayer1 = AVAudioPlayer()
    
    
    override func didMove(to view: SKView)
    {
        if textureSize == CGSize.zero { textureSize = virusTexture.size() }
        
        // Setup Viruses
        for _ in 1...numOfViruses
        {
            let v = CreateVirus(texture: virusTexture, health: 1, movementSpeed: 20.0)
            
            inactiveViruses.insert(v)
            
            v.position = CGPoint(x: w - 100.0, y: h/2)
            v.size = CGSize(width: textureSize.width * 0.2, height: textureSize.height * 0.2)
            v.physicsBody = SKPhysicsBody(circleOfRadius: textureSize.width)
            v.physicsBody?.affectedByGravity = false
            v.physicsBody?.collisionBitMask = 0x00000000

            v.isAlive = false
            
            addChild(v)
        }
        
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
        
        //let playSound = SKAction.playSoundFileNamed("Sounds/Beep.mp3", waitForCompletion: true)
        //self.run(playSound)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        super.touchesEnded(touches, with: event)
        
        //audioPlayer1.play()
    
        guard let position = touches.first?.location(in: self) else { return }
        guard let tappedObject = nodes(at: position).first(where: {$0 is Virus}) as? Virus else { return }
        
        // What should be done with the tapped Virus?
        tappedObject.DecreaseHealth(by: 1)
        //audioPlayer1.play()
        
        if !tappedObject.isAlive
        {
            activeViruses.remove(tappedObject)
            inactiveViruses.insert(tappedObject)
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    func printHelloMessage()
    {
        print("Hello from GameScene")
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
        let origionalScale = textureSize.width * 0.2
        let modification = CGFloat(abs(sin(currentTime)))
        let newScale = origionalScale + (origionalScale * modification)
        
        let resizeVirus = SKAction.resize(toWidth: newScale, height: newScale, duration: 0.5)
        
        // Code called each frame before rendering
        
        for v in inactiveViruses {
            v.isAlive = false // Inactive viruses shouldn't be alive
            v.Update()
        }
        
        for v in activeViruses {
            // Manage current active virus
            v.Update()
            v.run(resizeVirus)
        }
        
        let pos = CGPoint(x: CGFloat(Float.random(in: 1.0...Float(w))), y: CGFloat(Float.random(in: 1.0...Float(h))))
        
        SpawnVirus(at: pos, health: 1, speed: 20.0)
        
    }
    
    
    func CreateVirus(texture tex: SKTexture, health h: Int, movementSpeed mS: Float) -> (Virus)
    {
        let v = Virus(texture: tex, color: UIColor.clear, size: tex.size(), health: h, movementSpeed: mS)
        
        return v;
    }
    
    func SpawnVirus(at p: CGPoint, health h: Int, speed s: Float)
    {
        
        if inactiveViruses.isEmpty
        {
            print("No viruses to spawn!")
            return
        }
        print("Spawned virus")
        
        let v = inactiveViruses.popFirst()
        activeViruses.insert(v!)
        
        v?.position = p
        v?.health = h
        v?.movementSpeed = s
        v?.isAlive = true
        
    }
    
}
