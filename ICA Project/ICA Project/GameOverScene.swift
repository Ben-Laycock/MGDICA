//
//  GameOverScene.swift
//  ICA Project
//
//  Created by Ben on 02/12/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit


class GameOverScene: SKScene
{

    var mMainMenuScene : MainMenuScene!
    var mGameScene : GameScene!
    
    let mScreenWidth = UIScreen.main.bounds.width
    let mScreenHeight = UIScreen.main.bounds.height
        
    let mGameOverTitleLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mPlayAgainButton = SKSpriteNode(imageNamed: "PlayAgainButton")
    let mMainMenuButton = SKSpriteNode(imageNamed: "MainMenuButton")
    
    var mHasCompleteSetup = false
    
    override func didMove(to view: SKView)
    {
        
        if mHasCompleteSetup
        {
           return
        }
        
        mGameOverTitleLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 2)
        mGameOverTitleLabel.text = "Game Over"
        mGameOverTitleLabel.fontSize = 48
        addChild(mGameOverTitleLabel)
        
        mPlayAgainButton.name = "PlayAgainButton"
        mPlayAgainButton.position = CGPoint(x: 200, y: mScreenHeight - mScreenHeight / 4)
        mPlayAgainButton.size = SKTexture(imageNamed: "PlayAgainButton").size() * 0.3
        addChild(mPlayAgainButton)
        
        mMainMenuButton.name = "MainMenuButton"
        mMainMenuButton.position = CGPoint(x: 200, y: (mScreenHeight / 2) - mScreenHeight / 4)
        mMainMenuButton.size = SKTexture(imageNamed: "MainMenuButton").size() * 0.3
        addChild(mMainMenuButton)
     
        mHasCompleteSetup = true
        
    }
    
    func loadGameScene()
    {
        if !mGameScene.ResetScene()
        {
            return
        }
        view?.presentScene(mGameScene, transition: .reveal(with: SKTransitionDirection.down, duration: 1.0))
        //view?.presentScene(mGameScene)
    }
    
    func loadMainMenuScene()
    {
        view?.presentScene(mMainMenuScene, transition: .reveal(with: SKTransitionDirection.right, duration: 1.0))
        //view?.presentScene(mMainMenuScene)
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
            
            
            if node.name == "PlayAgainButton"
            {
                loadGameScene()
            }
            
            if node.name == "MainMenuButton"
            {
                loadMainMenuScene()
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
