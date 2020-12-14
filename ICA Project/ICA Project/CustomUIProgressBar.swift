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
        // Add children to specified scenes
        view.addChild(self)
        view.addChild(mBackgroundImage)
        view.addChild(mForegroundImage)
        view.addChild(mProgressText)
        
        // Set position of SKNodes
        mBackgroundImage.position = self.position
        mForegroundImage.position = self.position
        mProgressText.position = CGPoint(x: self.position.x + mSize.width/2, y: self.position.y)
        
        // Set background and foreground sizes
        mBackgroundImage.size = mSize
        mForegroundImage.size = mSize
        // Set font size
        mProgressText.fontSize = mSize.height/2
        
        // Set Z positions for SKNodes
        mBackgroundImage.zPosition = 50
        mForegroundImage.zPosition = 100
        mProgressText.zPosition = 101
        
        // Set text alignment modes
        mProgressText.verticalAlignmentMode = .center
        mProgressText.horizontalAlignmentMode = .center
    }
    
    func SetAnchorPoint(_ anchor: CGPoint)
    {
        // Set anchor point for the bar
        mBackgroundImage.anchorPoint = anchor
        mForegroundImage.anchorPoint = anchor
    }
    
    func SetPosition(_ position: CGPoint)
    {
        // Set the bar background and foreground to the bars position
        mBackgroundImage.position = position
        mForegroundImage.position = position
        // Set text to be in the middle of the bar
        mProgressText.position = CGPoint(x: position.x + mSize.width/2, y: position.y)
    }
    
    func SetSize(_ size: CGSize)
    {
        // Update the size of all elements of the progress bar
        mSize = size
        mBackgroundImage.size = size
        mForegroundImage.size = size
        // Update the font size
        mProgressText.fontSize = size.height/2
        
        // Move the text position to be in the middle of the bar
        mProgressText.position = CGPoint(x: position.x + mSize.width/2, y: position.y)
    }

    func SetMaxValue(_ maxValue: CGFloat)
    {
        // Update the max value of the bar
        mMaxValue = maxValue
    }
    
    func SetValue(_ value: CGFloat)
    {
        // Set value to passed value (Make sure it is within the range of the bar)
        mValue = Clamp(value, low: 0, high: mMaxValue)
    }
    
    func UpdateRender()
    {
        // Object is not active so return
        if !self.IsActive() { return }
        
        // Calculate the percentage of the bar to fill
        let percentageSizeX = mValue / mMaxValue
        // Calculate the width of the bar by getting the percentage of the full size
        let newSizeX = percentageSizeX * mSize.width
        // Set the size of the bar
        mForegroundImage.size = CGSize(width: newSizeX, height: mSize.height)
        // Update text
        mProgressText.text = "\(Int(percentageSizeX*100))%"
    }
    
    func Toggle(_ b: Bool)
    {
        // Set all SKNodes active states to passed bool
        self.SetActive(b)
        mBackgroundImage.SetActive(b)
        mForegroundImage.SetActive(b)
        mProgressText.SetActive(b)
    }
    
}
