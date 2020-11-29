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


// Maybe needs to be put into a helpers swift file later
func MagCG(_ vector: CGVector) -> (CGFloat)
{
    return CGFloat(sqrtf(Float(vector.dx * vector.dx + vector.dy * vector.dy)))
}

func NormCG(_ vector: CGVector) -> (CGVector)
{
    var v = vector
    let mag = MagCG(v)
    v.dx /= mag
    v.dy /= mag
    return v
}


class Virus : SKSpriteNode
{
    
    var health : Int
    var movementSpeed : Float
    
    init(texture: SKTexture!, color: UIColor, size: CGSize, health: Int, movementSpeed : Float)
    {
        
        self.health = health
        self.movementSpeed = movementSpeed
        
        super.init(texture: texture, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func DecreaseHealth(by amount: Int)
    {
        
        self.health -= amount;
        if health <= 0 { self.removeFromParent() }
        
    }
    
    func MoveToTarget(at location: CGVector, precision pC: CGFloat)
    {
        
        // Position
        let p = CGVector(dx: self.position.x, dy: self.position.y)
        // Target
        let t = location
        
        // Direction to target
        var pT = CGVector(dx: t.dx - p.dx, dy: t.dy - p.dy)
        
        // Return if distance to target is less than the required precision
        if MagCG(pT) < pC
        {
            self.physicsBody?.velocity = CGVector.zero
            return
        }
        
        pT = NormCG(pT) // pT = Normalized vector in direction of the target
        
        let finalVector = CGVector(dx: pT.dx * CGFloat(movementSpeed), dy: pT.dy * CGFloat(movementSpeed))
        
        self.physicsBody?.velocity = finalVector
        //self.physicsBody?.applyForce(finalVector)
        
    }
    
}


func SpawnVirus(texture tex: SKTexture, health h: Int, movementSpeed mS: Float) -> (Virus)
{
    let v = Virus(texture: tex, color: UIColor.clear, size: tex.size(), health: h, movementSpeed: mS)
    
    return v;
}


class GameScene: SKScene
{
    
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    let virusTexture = SKTexture(imageNamed: "Virus")
    var textureSize = CGSize.zero
    let v = Virus(texture: SKTexture(imageNamed: "Virus"), color: UIColor.clear, size: SKTexture(imageNamed: "Virus").size(), health: 1, movementSpeed: 100.0)
    
    var audioPlayer1 = AVAudioPlayer()
    
    
    override func didMove(to view: SKView)
    {
        if textureSize == CGSize.zero { textureSize = virusTexture.size() }
        
        v.position = CGPoint(x: w - 100.0, y: h/2)
        v.physicsBody = SKPhysicsBody(circleOfRadius: textureSize.width)
        v.physicsBody?.affectedByGravity = false
        addChild(v)
        
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
        
        super.touchesEnded(touches, with: event)
        
        //audioPlayer1.play()
    
        guard let position = touches.first?.location(in: self) else { return }
        guard let tappedObject = nodes(at: position).first(where: {$0 is Virus}) as? Virus else { return }
        
        // What should be done with the tapped Virus?
        tappedObject.DecreaseHealth(by: 1)
        
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
        
        // Code called each frame before rendering
        v.MoveToTarget(at: CGVector(dx: w/2, dy: h/2), precision: 20.0)
        
        
    }
    
}
