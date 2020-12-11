//
//  Core.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit
import CoreMotion


class Core : SKSpriteNode
{

    var mHealth : Int
    
    init(texture: SKTexture!, color: UIColor, size: CGSize, health: Int)
    {
        
        self.mHealth = health
        
        super.init(texture: texture, color: color, size: size)
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Decreases health by given amount
    func DecreaseHealth(by amount: Int)
    {
        self.mHealth -= amount;
    }
    
    
    // Returns true if dead (else false)
    func IsDead() -> (Bool)
    {
        return mHealth <= 0
    }
    
}
