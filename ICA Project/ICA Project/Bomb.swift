//
//  Bomb.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit
import CoreMotion


class Bomb : SKSpriteNode
{
    
    var mScreenWidth : CGFloat = 0.0
    var mScreenHeight : CGFloat = 0.0
    
    var mMovementSpeed : Float
    var mExplosionRadius : Float
    var mExplosionDamage : Int
    var mIsAlive = false
    var mMovementDirection = CGVector.zero
    
    
    init(texture: SKTexture!, color: UIColor, size: CGSize, movementSpeed : Float, explosionRange: Float, explosionDamage: Int)
    {
        
        self.mMovementSpeed = movementSpeed
        self.mExplosionRadius = explosionRange
        self.mExplosionDamage = explosionDamage
        
        super.init(texture: texture, color: color, size: size)
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func Update()
    {
        
        if !mIsAlive || !IsActive() { return }
        
        MoveBomb()
        
    }
    
    
    func MoveBomb()
    {
        //self.physicsBody?.velocity = mMovementDirection * CGFloat(mMovementSpeed)
        self.physicsBody?.applyImpulse(mMovementDirection * CGFloat(mMovementSpeed))
        
        LockToScreen()
    }
    
    
    func LockToScreen()
    {
        if Int(position.x) > Int(mScreenWidth - size.width / 2)
        {
            position.x = mScreenWidth - size.width / 2
            self.physicsBody?.velocity.dx = 0
        }
        if position.x < size.width/2
        {
            position.x = size.width/2
            self.physicsBody?.velocity.dx = 0
        }
        
        if Int(position.y) > Int(mScreenHeight - size.height / 2)
        {
            position.y = mScreenHeight - size.height / 2
            self.physicsBody?.velocity.dy = 0
        }
        if position.y < size.height / 2
        {
            position.y = size.height / 2
            self.physicsBody?.velocity.dy = 0
        }
    }
    
}
