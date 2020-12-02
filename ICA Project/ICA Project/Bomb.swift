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

    var mMovementSpeed : Float
    var mExplosionRadius : Float
    var mExplosionDamage : Int
    var mIsAlive = false
    
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
        
        if mIsAlive
        {
            
        }
        else
        {
            self.position = CGPoint(x: -1000.0, y: -1000.0)
        }
        
    }
    
}
