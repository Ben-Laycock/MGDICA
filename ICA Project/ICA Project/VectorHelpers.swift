//
//  VectorHelpers.swift
//  ICA Project
//
//  Created by Ben on 30/11/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit


func MagCG(_ vector: CGVector) -> (CGFloat)
{
    return CGFloat(sqrtf(Float(vector.dx * vector.dx + vector.dy * vector.dy)))
}

func NormCG(_ vector: CGVector) -> (CGVector)
{
    var v = vector
    let mag = MagCG(v)
    v.dx /= mag
    v.dy /= mag
    return v
}

func Clamp(_ f: CGFloat, low l: CGFloat, high h: CGFloat) -> (CGFloat)
{
    return min(max(f, l), h)
}
