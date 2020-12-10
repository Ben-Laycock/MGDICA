//
//  Pill.swift
//  ICA Project
//
//  Created by Ben on 10/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

class Pill : SKSpriteNode
{
    
    var mHealingAmount : Int = 5
    var mIsAlive : Bool = false
 
    func IsDead() -> (Bool)
    {
        return !mIsAlive
    }
    
    func Update()
    {
        if !mIsAlive
        {
            self.isHidden = true
            return
        }
        
        if self.isHidden { self.isHidden = false }

    }
    
}
