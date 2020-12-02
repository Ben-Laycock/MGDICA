//
//  CGVectorExtensions.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

extension CGVector
{
    static func *(_ cg: CGVector, _ m: CGFloat) -> (CGVector)
    {
        return CGVector(dx: cg.dx * m, dy: cg.dy * m)
    }
    
    static func *(_ a: CGVector, _ b: CGVector) -> (CGVector)
    {
        return CGVector(dx: a.dx * b.dx, dy: a.dy * b.dy)
    }
    
    static func -(_ a: CGVector, _ b: CGVector) -> (CGVector)
    {
        return CGVector(dx: a.dx - b.dx, dy: a.dy - b.dy)
    }
    
    func Mag() -> (CGFloat)
    {
        return CGFloat(sqrtf(Float(dx * dx + dy * dy)))
    }
    
    func Norm() -> (CGVector)
    {
        return CGVector(dx: dx / Mag(), dy: dy / Mag())
    }
    
    mutating func Normilze()
    {
        let m = Mag()
        dx /= m
        dy /= m
    }
    
    func ToPoint() -> (CGPoint)
    {
        return CGPoint(x: dx, y: dy)
    }
}
