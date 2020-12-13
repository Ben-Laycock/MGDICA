//
//  CustomUIProgressBar.swift
//  ICA Project
//
//  Created by Ben on 13/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

class CustomUIProgressBar : SKNode
{
    
    override var isUserInteractionEnabled: Bool {
        set {}
        get { return false }
    }
    
    var mMaxValue : CGFloat = 100.0
    var mValue : CGFloat = 100.0
    var mSize : CGSize = CGSize(width: 100.0, height: 30.0)
    var mBackgroundImage = SKSpriteNode(imageNamed: "LightGrey")
    var mForegroundImage = SKSpriteNode(imageNamed: "Red")
    var mProgressText = SKLabelNode(fontNamed: "Noteworthy Bold")
    
    func Setup(_ view : SKScene)
    {
        view.addChild(self)
        view.addChild(mBackgroundImage)
        view.addChild(mForegroundImage)
        view.addChild(mProgressText)
        
        mBackgroundImage.position = self.position
        mForegroundImage.position = self.position
        mProgressText.position = CGPoint(x: self.position.x + mSize.width/2, y: self.position.y)
        
        mBackgroundImage.size = mSize
        mForegroundImage.size = mSize
        mProgressText.fontSize = mSize.height/2
        
        mBackgroundImage.zPosition = 50
        mForegroundImage.zPosition = 100
        mProgressText.zPosition = 101
        
        mProgressText.verticalAlignmentMode = .center
        mProgressText.horizontalAlignmentMode = .center
    }
    
    func SetAnchorPoint(_ anchor: CGPoint)
    {
        mBackgroundImage.anchorPoint = anchor
        mForegroundImage.anchorPoint = anchor
    }
    
    func SetPosition(_ position: CGPoint)
    {
        mBackgroundImage.position = position
        mForegroundImage.position = position
        mProgressText.position = CGPoint(x: position.x + mSize.width/2, y: position.y)
    }
    
    func SetSize(_ size: CGSize)
    {
        mSize = size
        mBackgroundImage.size = size
        mForegroundImage.size = size
        mProgressText.fontSize = size.height/2
        
        mProgressText.position = CGPoint(x: position.x + mSize.width/2, y: position.y)
    }

    func SetMaxValue(_ maxValue: CGFloat)
    {
        mMaxValue = maxValue
    }
    
    func SetValue(_ value: CGFloat)
    {
        mValue = Clamp(value, low: 0, high: mMaxValue)
    }
    
    func UpdateRender()
    {
        if !self.IsActive() { return }
        
        let percentageSizeX = mValue / mMaxValue
        let newSizeX = percentageSizeX * mSize.width
        mForegroundImage.size = CGSize(width: newSizeX, height: mSize.height)
        mProgressText.text = "\(Int(percentageSizeX*100))%"
    }
    
    func Toggle(_ b: Bool)
    {
        self.SetActive(b)
        mBackgroundImage.SetActive(b)
        mForegroundImage.SetActive(b)
        mProgressText.SetActive(b)
    }
    
}
