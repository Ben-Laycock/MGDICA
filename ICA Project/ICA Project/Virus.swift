//
//  VirusTest.swift
//  ICA Project
//
//  Created by Ben on 30/11/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit
import CoreMotion


class Virus : SKSpriteNode
{
    
    var health : Int
    var movementSpeed : Float
    var isAlive = false
    
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
    
    
    func Update()
    {
        
        if isAlive
        {
            MoveToTarget(at: CGVector.zero, precision: 20.0) // Replace CGVector.zero later
        }
        else
        {
            self.position = CGPoint(x: -1000.0, y: -1000.0)
        }
        
    }
    
    
    func DecreaseHealth(by amount: Int)
    {
        
        self.health -= amount;
        
        // Manage virus death
        if health <= 0
        {
            self.isAlive = false
        }
        
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
