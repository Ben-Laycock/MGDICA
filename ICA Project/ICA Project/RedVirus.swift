//
//  RedVirus.swift
//  ICA Project
//
//  Created by Ben on 05/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit
import CoreMotion


class RedVirus : SKSpriteNode
{
    
    var mHealth : Int = 0
    var mMovementSpeed : Float = 0.0
    var mTimeSpawned : Double = 0.0
    var mDamage : Int = 1
    var mMaxSpeed : CGFloat = 200.0
    var mCanMoveToTarget : Bool = true

    var mTarget : CGPoint = CGPoint.zero
    
    
    func Setup(health h: Int, speed s: Float, timeSpawned t: Double, damage d: Int)
    {
        self.mHealth = h
        self.mMovementSpeed = s
        self.mTimeSpawned = t
        self.mDamage = d
    }
    
    
    func Update()
    {
        if IsDead() || !IsActive() { return }

        // What should be done if alive?
        MoveToTarget(at: mTarget, precision: 100.0)
    }
    
    
    // Set the current target
    func SetTarget(target t: CGPoint)
    {
        mTarget = t
    }
    
    
    // Decreases health by given amount
    func DecreaseHealth(by amount: Int)
    {
        self.mHealth -= amount;
    }
    
    
    // Returns true if dead (else false)
    func IsDead() -> (Bool)
    {
        return self.mHealth <= 0
    }
    
    
    func MoveToTarget(at location: CGPoint, precision pC: CGFloat)
    {
        // Position
        let p = self.position.ToVector()
        // Target
        let t = location.ToVector()
        
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
        
        self.physicsBody?.applyImpulse(finalVector)
        
        if (self.physicsBody?.velocity.Mag())! > mMaxSpeed
        {
            self.physicsBody?.velocity = (self.physicsBody?.velocity.Norm())! * mMaxSpeed
        }
    }
    
}
