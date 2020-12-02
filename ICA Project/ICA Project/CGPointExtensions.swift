//
//  CGPointExtensions.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

extension CGPoint
{
    func ToVector() -> (CGVector)
    {
        return CGVector(dx: x, dy: y)
    }
}
