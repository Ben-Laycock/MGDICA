//
//  Helpers.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

func Clamp(_ f: CGFloat, low l: CGFloat, high h: CGFloat) -> (CGFloat)
{
    return min(max(f, l), h)
}
