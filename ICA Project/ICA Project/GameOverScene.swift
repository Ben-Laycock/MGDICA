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
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mHighScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mPlayAgainButton = SKSpriteNode(imageNamed: "PlayAgainButton")
    let mMainMenuButton = SKSpriteNode(imageNamed: "MainMenuButton")
    
    // Players score from most recent game
    var mScoreFromLastGame = 0
    
    // Highest saved score
    var mSavedHighScore = 0
    
    // New high score?
    var mNewHighScore : Bool = false
    
    let savedData = UserDefaults.standard
    
    var mHasCompleteSetup = false
    
    
    override func didMove(to view: SKView)
    {
        
        mSavedHighScore = savedData.integer(forKey: "HighScore")
        
        if mScoreFromLastGame > mSavedHighScore
        {
            mSavedHighScore = mScoreFromLastGame
            savedData.set(mScoreFromLastGame, forKey: "HighScore")
            mNewHighScore = true
        }
        
        mScoreLabel.text = "Score: \(mScoreFromLastGame)"
        
        if mNewHighScore
        {
            mHighScoreLabel.text = "NEW High Score: \(mSavedHighScore)"
        }
        else
        {
            mHighScoreLabel.text = "High Score: \(mSavedHighScore)"
        }
        
        // Dont run code past this point if setup has previously been completed
        if mHasCompleteSetup { return }
        
        // Game over label
        mGameOverTitleLabel.position = CGPoint(x: mScreenWidth / 3 * 2, y: mScreenHeight / 4 * 3)
        mGameOverTitleLabel.text = "Game Over"
        mGameOverTitleLabel.fontSize = 48
        addChild(mGameOverTitleLabel)
        
        // Score label
        mScoreLabel.position = CGPoint(x: mScreenWidth / 3 * 2, y: mScreenHeight / 4)
        mScoreLabel.fontSize = 48
        addChild(mScoreLabel)
        
        // High Score label
        mHighScoreLabel.position = CGPoint(x: mScreenWidth / 3 * 2, y: mScreenHeight / 4 * 2)
        mHighScoreLabel.fontSize = 48
        addChild(mHighScoreLabel)
        
        // Play again button
        mPlayAgainButton.name = "PlayAgainButton"
        mPlayAgainButton.position = CGPoint(x: 200, y: mScreenHeight - mScreenHeight / 4)
        mPlayAgainButton.size = SKTexture(imageNamed: "PlayAgainButton").size() * 0.3
        addChild(mPlayAgainButton)
        
        // Main menu button
        mMainMenuButton.name = "MainMenuButton"
        mMainMenuButton.position = CGPoint(x: 200, y: (mScreenHeight / 2) - mScreenHeight / 4)
        mMainMenuButton.size = SKTexture(imageNamed: "MainMenuButton").size() * 0.3
        addChild(mMainMenuButton)
     
        mHasCompleteSetup = true
        
    }
    
    
    func loadGameScene()
    {
        if !mGameScene.ResetScene() { return }
        
        view?.presentScene(mGameScene, transition: .reveal(with: SKTransitionDirection.down, duration: 1.0))
    }
    
    
    func loadMainMenuScene()
    {
        view?.presentScene(mMainMenuScene, transition: .reveal(with: SKTransitionDirection.right, duration: 1.0))
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
        
    }
    
}
