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
    
    // Main Menu
    let mPlayButton = SKSpriteNode(imageNamed: "PlayButton")
    let mInfoButton = SKSpriteNode(imageNamed: "InfoButton")
    
    // Info Menu
    let mBackButton = SKSpriteNode(imageNamed: "CancelButton")
    let mVirusImage = SKSpriteNode(imageNamed: "Virus")
    let mRedVirusImage = SKSpriteNode(imageNamed: "RedVirus")
    let mBombImage = SKSpriteNode(imageNamed: "Mine")
    let mPillImage = SKSpriteNode(imageNamed: "Pill")
    let mCoreImage = SKSpriteNode(imageNamed: "Core")
    
    let mVirusInfo = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mRedVirusInfo = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mBombInfo = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mPillInfo = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mCoreInfo = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    var mHasCompleteSetup = false
    
    override func didMove(to view: SKView)
    {
        
        if mHasCompleteSetup
        {
           return
        }
        
        // Main menu setup
        mMainMenuTitleLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 2)
        mMainMenuTitleLabel.text = "Main Menu"
        mMainMenuTitleLabel.fontSize = 48
        addChild(mMainMenuTitleLabel)
        
        mPlayButton.name = "PlayButton"
        mPlayButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 4)
        mPlayButton.size = SKTexture(imageNamed: "PlayButton").size() * 0.3
        addChild(mPlayButton)
        
        mInfoButton.name = "InfoButton"
        mInfoButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 2)
        mInfoButton.size = SKTexture(imageNamed: "InfoButton").size() * 0.3
        addChild(mInfoButton)
     
        
        // Info menu setup
        mBackButton.name = "BackButton"
        mBackButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 5)
        mBackButton.size = SKTexture(imageNamed: "CancelButton").size() * 0.3
        addChild(mBackButton)
        
        // Virus
        mVirusImage.name = "VirusImage"
        mVirusImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6)
        mVirusImage.size = SKTexture(imageNamed: "Virus").size() * 0.3
        addChild(mVirusImage)
        
        mVirusInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6)
        mVirusInfo.horizontalAlignmentMode = .left
        mVirusInfo.verticalAlignmentMode = .center
        mVirusInfo.text = "Virus: Click to destroy"
        mVirusInfo.fontSize = 24
        addChild(mVirusInfo)
        
        // Red Virus
        mRedVirusImage.name = "RedVirusImage"
        mRedVirusImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 2)
        mRedVirusImage.size = SKTexture(imageNamed: "RedVirus").size() * 0.3
        addChild(mRedVirusImage)
        
        mRedVirusInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 2)
        mRedVirusInfo.horizontalAlignmentMode = .left
        mRedVirusInfo.verticalAlignmentMode = .center
        mRedVirusInfo.text = "Red Virus: Swipe them away from the core"
        mRedVirusInfo.fontSize = 24
        addChild(mRedVirusInfo)
        
        // Bomb
        mBombImage.name = "BombImage"
        mBombImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 3)
        mBombImage.size = SKTexture(imageNamed: "Mine").size() * 0.3
        addChild(mBombImage)
        
        mBombInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 3)
        mBombInfo.horizontalAlignmentMode = .left
        mBombInfo.verticalAlignmentMode = .center
        mBombInfo.text = "Bomb: Click to destroy all nearby viruses"
        mBombInfo.fontSize = 24
        addChild(mBombInfo)
        
        // Pill
        mPillImage.name = "PillImage"
        mPillImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 4)
        mPillImage.size = SKTexture(imageNamed: "Pill").size() * 0.3
        addChild(mPillImage)
        
        mPillInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 4)
        mPillInfo.horizontalAlignmentMode = .left
        mPillInfo.verticalAlignmentMode = .center
        mPillInfo.text = "Pill: Drag to the core to heal it"
        mPillInfo.fontSize = 24
        addChild(mPillInfo)
        
        // Core
        mCoreImage.name = "CoreImage"
        mCoreImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 5)
        mCoreImage.size = SKTexture(imageNamed: "Core").size() * 0.2
        addChild(mCoreImage)
        
        mCoreInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 5)
        mCoreInfo.horizontalAlignmentMode = .left
        mCoreInfo.verticalAlignmentMode = .center
        mCoreInfo.text = "Core: Protect it from the viruses"
        mCoreInfo.fontSize = 24
        addChild(mCoreInfo)
        
        // Disable info menu
        ToggleInfoMenu()
        
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
            
            if node.name == "InfoButton"
            {
                ToggleMainMenu()
                ToggleInfoMenu()
            }
            
            if node.name == "BackButton"
            {
                ToggleInfoMenu()
                ToggleMainMenu()
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
    }
    
    func ToggleMainMenu()
    {
        mMainMenuTitleLabel.isHidden = !mMainMenuTitleLabel.isHidden
        mPlayButton.isHidden = !mPlayButton.isHidden
        mInfoButton.isHidden = !mInfoButton.isHidden
    }
    
    func ToggleInfoMenu()
    {
        mBackButton.isHidden = !mBackButton.isHidden
        mVirusImage.isHidden = !mVirusImage.isHidden
        mRedVirusImage.isHidden = !mRedVirusImage.isHidden
        mBombImage.isHidden = !mBombImage.isHidden
        mPillImage.isHidden = !mPillImage.isHidden
        mCoreImage.isHidden = !mCoreImage.isHidden
        
        mVirusInfo.isHidden = !mVirusInfo.isHidden
        mRedVirusInfo.isHidden = !mRedVirusInfo.isHidden
        mBombInfo.isHidden = !mBombInfo.isHidden
        mPillInfo.isHidden = !mPillInfo.isHidden
        mCoreInfo.isHidden = !mCoreInfo.isHidden
    }
    
}
