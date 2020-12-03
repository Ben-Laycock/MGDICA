//
//  MainMenuScene.swift
//  ICA Project
//
//  Created by LAYCOCK, BEN (Student) on 29/11/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit


class MainMenuScene: SKScene
{

    var mGameScene : GameScene!
    
    let mScreenWidth = UIScreen.main.bounds.width
    let mScreenHeight = UIScreen.main.bounds.height
        
    let mMainMenuTitleLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mPlayButton = SKSpriteNode(imageNamed: "PlayButton")
    let mOptionsButton = SKSpriteNode(imageNamed: "InfoButton")
    
    var mHasCompleteSetup = false
    
    override func didMove(to view: SKView)
    {
        
        if mHasCompleteSetup
        {
           return
        }
        
        mMainMenuTitleLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 2)
        mMainMenuTitleLabel.text = "Main Menu"
        mMainMenuTitleLabel.fontSize = 48
        addChild(mMainMenuTitleLabel)
        
        mPlayButton.name = "PlayButton"
        mPlayButton.position = CGPoint(x: 200, y: mScreenHeight - mScreenHeight / 4)
        mPlayButton.size = SKTexture(imageNamed: "PlayButton").size() * 0.3
        addChild(mPlayButton)
        
        mOptionsButton.name = "OptionsButton"
        mOptionsButton.position = CGPoint(x: 200, y: (mScreenHeight / 2) - mScreenHeight / 4)
        mOptionsButton.size = SKTexture(imageNamed: "InfoButton").size() * 0.3
        addChild(mOptionsButton)
     
        mHasCompleteSetup = true
        
    }
    
    func loadScene()
    {
        view?.presentScene(mGameScene, transition: .reveal(with: SKTransitionDirection.left, duration: 1.0))
        //view?.presentScene(mGameScene)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        super.touchesEnded(touches, with: event)
        
        for touch in touches
        {
            let pos = touch.location(in: self) // Position of the touch
            let node = atPoint(pos) // Node at the touch position
            
            if node.name == "PlayButton"
            {
                loadScene()
            }
            
            if node.name == "OptionsButton"
            {
                
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
        // Code called each frame before rendering
        
        
    }
    
}
