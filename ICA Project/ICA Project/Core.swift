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
    var mIsDestroyed = false
    
    init(texture: SKTexture!, color: UIColor, size: CGSize, health: Int)
    {
        
        self.mHealth = health
        
        super.init(texture: texture, color: color, size: size)
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func Update()
    {
        
        if !mIsDestroyed
        {
            
        }
        else
        {
            self.position = CGPoint(x: -1000.0, y: -1000.0)
        }
        
    }
    
}
