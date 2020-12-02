//
//  UIViewExtensions.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

extension UIView
{
    func Shake(horizontalShake x: CGFloat, verticalShake y: CGFloat)
    {
        self.transform = CGAffineTransform(translationX: x, y: y)
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations:
            {
                self.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }
}
