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

    // Scenes
    var mMainMenuScene : MainMenuScene!
    var mGameScene : GameScene!
    
    // Screen
    let mScreenWidth = UIScreen.main.bounds.width
    let mScreenHeight = UIScreen.main.bounds.height
        
    // Text size
    var mTextFontSize : CGFloat = 24
    var mTitleFontSize : CGFloat = 48
    
    let mGameOverTitleLabel = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mScoreLabel = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mHighScoreLabel = SKLabelNode(fontNamed: "Noteworthy Bold")
    
    let mPlayAgainButton = SKSpriteNode(imageNamed: "PlayAgainButton")
    let mMainMenuButton = SKSpriteNode(imageNamed: "MainMenuButton")
    
    // Players score from most recent game
    var mScoreFromLastGame = 0
    
    // Highest saved score
    var mSavedHighScore = 0
    
    // New high score?
    var mNewHighScore : Bool = false
    
    // Audio System
    var mAudioSystem : AudioSystem!
    
    let savedData = UserDefaults.standard
    
    var mHasCompleteSetup = false
    
    
    override func didMove(to view: SKView)
    {
        
        // Calculate text sizes
        mTextFontSize = mScreenHeight/15
        mTitleFontSize = mScreenHeight/10
        
        if nil != mAudioSystem { mAudioSystem.UpdateSettings() }
        
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
            mHighScoreLabel.text = "New High Score: \(mSavedHighScore)"
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
        mGameOverTitleLabel.fontSize = mTitleFontSize
        addChild(mGameOverTitleLabel)
        
        // High Score label
        mHighScoreLabel.position = CGPoint(x: mScreenWidth / 3 * 2, y: mScreenHeight / 4 * 2)
        mHighScoreLabel.fontSize = mTextFontSize
        addChild(mHighScoreLabel)
        
        // Score label
        mScoreLabel.position = CGPoint(x: mScreenWidth / 3 * 2, y: mScreenHeight / 4)
        mScoreLabel.fontSize = mTextFontSize
        addChild(mScoreLabel)
        
        // Play again button
        mPlayAgainButton.name = "PlayAgainButton"
        mPlayAgainButton.position = CGPoint(x: 200, y: mScreenHeight / 4 * 3)
        mPlayAgainButton.size = CGSize(width: mScreenHeight/8, height: mScreenHeight/8)
        addChild(mPlayAgainButton)
        
        // Main menu button
        mMainMenuButton.name = "MainMenuButton"
        mMainMenuButton.position = CGPoint(x: 200, y: mScreenHeight / 4)
        mMainMenuButton.size = CGSize(width: mScreenHeight/8, height: mScreenHeight/8)
        addChild(mMainMenuButton)
     
        // Setup audio system
        mAudioSystem = AudioSystem()
        mAudioSystem.Setup()
        
        mHasCompleteSetup = true
        
    }
    
    
    func loadGameScene()
    {
        if !mGameScene.ResetScene() { return }
     
        mAudioSystem.PlaySound(name: "click", from: self)
        
        view?.presentScene(mGameScene, transition: .reveal(with: SKTransitionDirection.down, duration: 1.0))
    }
    
    
    func loadMainMenuScene()
    {
        mAudioSystem.PlaySound(name: "click", from: self)
        
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
