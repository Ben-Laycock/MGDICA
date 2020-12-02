//
//  CGSizeExtensions.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

extension CGSize
{
    static func *(_ cg: CGSize, _ m: CGFloat) -> (CGSize)
    {
        return CGSize(width: cg.width * m, height: cg.height * m)
    }
    
    static func /(_ cg: CGSize, _ m: CGFloat) -> (CGSize)
    {
        return CGSize(width: cg.width / m, height: cg.height / m)
    }
}
