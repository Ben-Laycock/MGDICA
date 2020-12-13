//
//  CustomUIToggle.swift
//  ICA Project
//
//  Created by Ben on 12/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit

class CustomUIToggle : SKNode
{
    
    override var isUserInteractionEnabled: Bool {
        set {}
        get { return true }
    }
    
    var mSelected : Bool = false
    var mOnImage = SKSpriteNode(imageNamed: "CheckboxSelected")
    var mOffImage = SKSpriteNode(imageNamed: "Checkbox")
    var mCanDeactivateOnTouch : Bool = true
    var mCanActivateOnTouch : Bool = true
    
    func Setup(toggleName name: String, _ view : SKScene)
    {
        view.addChild(self)
        view.addChild(mOnImage)
        view.addChild(mOffImage)
        
        mOnImage.name = name + "On"
        mOffImage.name = name + "Off"
        
        mOnImage.position = self.position
        mOffImage.position = self.position
        
        UpdateRender()
    }
    
    func IsSelected() -> (Bool)
    {
        return mSelected
    }
    
    func ToggleSelected()
    {
        if !self.IsActive() { return }
        
        mSelected = !mSelected
        
        UpdateRender()
    }
    
    func SetSelected(_ state: Bool)
    {
        if !self.IsActive() { return }
        
        mSelected = state
        
        UpdateRender()
    }
    
    func UpdateRender()
    {
        if !self.IsActive() { return }
        
        mSelected ? mOnImage.SetActive(true) : mOnImage.SetActive(false)
        mSelected ? mOffImage.SetActive(false) : mOffImage.SetActive(true)
    }
    
    func SetScale(_ scaleX: CGFloat, _ scaleY: CGFloat)
    {
        mOnImage.size = CGSize(width: scaleX, height: scaleY)
        mOffImage.size = CGSize(width: scaleX, height: scaleY)
    }
    
    func touchDetected(_ nodeName: String)
    {
        if nodeName == mOnImage.name && mCanDeactivateOnTouch
        {
            SetSelected(false)
        }
        if nodeName == mOffImage.name && mCanActivateOnTouch
        {
            SetSelected(true)
        }
    }
    
    func Toggle(_ b: Bool)
    {
        self.SetActive(b)
        b ? mSelected ? mOnImage.SetActive(b) : mOnImage.SetActive(false) : mOnImage.SetActive(b)
        b ? mSelected ? mOffImage.SetActive(false) : mOffImage.SetActive(b) : mOffImage.SetActive(b)
    }
    
}
