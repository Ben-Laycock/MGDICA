//
//  SKNodeExtensions.swift
//  ICA Project
//
//  Created by Ben on 11/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

extension SKNode
{
    func SetActive(_ b: Bool)
    {
        self.isHidden = !b
    }
    
    func IsActive() -> (Bool)
    {
        return !self.isHidden
    }
}
