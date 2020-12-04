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
    
    var mHealth : Int
    var mMovementSpeed : Float
    var mIsAlive = false
    var mTargetPosition = CGPoint.zero
    var mDamageRange : CGFloat = CGFloat(20.0)
    var mTimeSpawned : Double = Double(0)
    
    init(texture: SKTexture!, color: UIColor, size: CGSize, health: Int, movementSpeed : Float)
    {
        
        self.mHealth = health
        self.mMovementSpeed = movementSpeed
        
        super.init(texture: texture, color: color, size: size)
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func Update()
    {
        
        if mIsAlive
        {
            MoveToTarget(at: mTargetPosition.ToVector(), precision: 20.0) // Replace CGVector.zero later
        }
        else
        {
            self.position = CGPoint(x: -1000.0, y: -1000.0)
        }
        
    }
    
    
    func DecreaseHealth(by amount: Int)
    {
        
        self.mHealth -= amount;
        
        // Manage virus death
        if mHealth <= 0
        {
            self.mIsAlive = false
        }
        
    }
    
    
    func MoveToTarget(at location: CGVector, precision pC: CGFloat)
    {
        
        // Position
        let p = CGVector(dx: self.position.x, dy: self.position.y)
        // Target
        let t = location
        
        // Direction to target
        var pT = t - p
        
        // Return if distance to target is less than the required precision
        if pT.Mag() < pC
        {
            self.physicsBody?.velocity = CGVector.zero
            return
        }
        
        pT.Normalize() // pT = Normalized vector in direction of the target
        
        let finalVector = pT * CGFloat(mMovementSpeed)
        
        self.physicsBody?.velocity = finalVector
        //self.physicsBody?.applyForce(finalVector)
        
    }
    
}
