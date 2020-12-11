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
    let mOptionsButton = SKSpriteNode(imageNamed: "InfoButton")
    let mInfoButton = SKSpriteNode(imageNamed: "InfoButton")
    
    
    // Options Menu
    let mOptionsBackButton = SKSpriteNode(imageNamed: "CancelButton")
    let mAudioOptionLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mDisableAudioButton = SKSpriteNode(imageNamed: "CheckboxSelected")
    let mEnableAudioButton = SKSpriteNode(imageNamed: "Checkbox")
    var mAudioEnabled : Bool = true
    
    
    // Info Menu
    let mInfoBackButton = SKSpriteNode(imageNamed: "CancelButton")
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
    
    
    var mSavedData = UserDefaults.standard
    var mHasCompleteSetup : Bool = false
    
    
    override func didMove(to view: SKView)
    {
        
        mAudioEnabled = mSavedData.bool(forKey: "AudioEnabled")
        
        if mHasCompleteSetup { return }
        
        // ===================  Main menu setup  ===================
        mMainMenuTitleLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 2)
        mMainMenuTitleLabel.text = "Main Menu"
        mMainMenuTitleLabel.fontSize = 48
        addChild(mMainMenuTitleLabel)
        
        // Play button
        mPlayButton.name = "PlayButton"
        mPlayButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 4)
        mPlayButton.size = SKTexture(imageNamed: "PlayButton").size() * 0.3
        addChild(mPlayButton)
        
        // Options button
        mOptionsButton.name = "OptionsButton"
        mOptionsButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 3)
        mOptionsButton.size = SKTexture(imageNamed: "InfoButton").size() * 0.3
        addChild(mOptionsButton)
        
        // Info button
        mInfoButton.name = "InfoButton"
        mInfoButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 2)
        mInfoButton.size = SKTexture(imageNamed: "InfoButton").size() * 0.3
        addChild(mInfoButton)
        
        
        // ===================  Options menu setup  ===================
        mOptionsBackButton.name = "OptionsBackButton"
        mOptionsBackButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 5)
        mOptionsBackButton.size = SKTexture(imageNamed: "CancelButton").size() * 0.3
        addChild(mOptionsBackButton)
        
        mAudioOptionLabel.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 2)
        mAudioOptionLabel.verticalAlignmentMode = .center
        mAudioOptionLabel.text = "Audio"
        mAudioOptionLabel.fontSize = 36
        addChild(mAudioOptionLabel)
        
        mDisableAudioButton.name = "DisableAudio"
        mDisableAudioButton.size = SKTexture(imageNamed: "CheckboxSelected").size() * 0.15
        mDisableAudioButton.position = CGPoint(x: mScreenWidth / 3 + mAudioOptionLabel.frame.width/2 + mDisableAudioButton.size.width/2 + 20, y: mScreenHeight / 2)
        addChild(mDisableAudioButton)
        
        mEnableAudioButton.name = "EnableAudio"
        mEnableAudioButton.size = SKTexture(imageNamed: "Checkbox").size() * 0.15
        mEnableAudioButton.position = CGPoint(x: mScreenWidth / 3 + mAudioOptionLabel.frame.width/2 + mEnableAudioButton.size.width/2 + 20, y: mScreenHeight / 2)
        addChild(mEnableAudioButton)
        
        
        // ===================  Info menu setup  ===================
        mInfoBackButton.name = "InfoBackButton"
        mInfoBackButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 5)
        mInfoBackButton.size = SKTexture(imageNamed: "CancelButton").size() * 0.3
        addChild(mInfoBackButton)
        
        // Virus
        mVirusImage.name = "VirusImage"
        mVirusImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6)
        mVirusImage.size = SKTexture(imageNamed: "Virus").size() * 0.3
        addChild(mVirusImage)
        
        mVirusInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6)
        mVirusInfo.horizontalAlignmentMode = .left
        mVirusInfo.verticalAlignmentMode = .center
        mVirusInfo.text = "Virus: Click to destroy / Hit them with bombs"
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
        mRedVirusInfo.text = "Red Virus: Swipe away / Hit with bombs"
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
        mBombInfo.text = "Bomb: Hit viruses to cause an explosion"
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
        ToggleOptionsMenu(on: false)
        ToggleInfoMenu(on: false)
        
        mHasCompleteSetup = true
        
    }
    
    
    func loadScene()
    {
        if !mGameScene.ResetScene() { return }
        
        view?.presentScene(mGameScene, transition: .reveal(with: SKTransitionDirection.left, duration: 1.0))
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
                ToggleMainMenu(on: false)
                ToggleOptionsMenu(on: false)
                ToggleInfoMenu(on: true)
            }
            
            if node.name == "OptionsButton"
            {
                ToggleMainMenu(on: false)
                ToggleInfoMenu(on: false)
                ToggleOptionsMenu(on: true)
            }
            
            if node.name == "InfoBackButton"
            {
                ToggleInfoMenu(on: false)
                ToggleOptionsMenu(on: false)
                ToggleMainMenu(on: true)
            }
            
            
            // Options menu
            if node.name == "OptionsBackButton"
            {
                ToggleInfoMenu(on: false)
                ToggleOptionsMenu(on: false)
                ToggleMainMenu(on: true)
            }
            
            if node.name == "DisableAudio"
            {
                mAudioEnabled = false
                mSavedData.set(mAudioEnabled, forKey: "AudioEnabled")
                mDisableAudioButton.SetActive(false)
                mEnableAudioButton.SetActive(true)
            }
            
            if node.name == "EnableAudio"
            {
                mAudioEnabled = true
                mSavedData.set(mAudioEnabled, forKey: "AudioEnabled")
                mEnableAudioButton.SetActive(false)
                mDisableAudioButton.SetActive(true)
            }
        }
        
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
    }
    
    
    func ToggleMainMenu(on status: Bool)
    {
        mMainMenuTitleLabel.SetActive(status)
        mPlayButton.SetActive(status)
        mInfoButton.SetActive(status)
        mOptionsButton.SetActive(status)
    }
    
    
    func ToggleOptionsMenu(on status: Bool)
    {
        mOptionsBackButton.SetActive(status)
        mAudioOptionLabel.SetActive(status)

        mDisableAudioButton.SetActive(status)
        mEnableAudioButton.SetActive(status)
        
        // Options menu is being enabled
        if true == status
        {
            // Audio is disabled
            if false == mAudioEnabled
            {
                mDisableAudioButton.SetActive(false)
                mEnableAudioButton.SetActive(true)
            }
            else
            {
                mEnableAudioButton.SetActive(false)
                mDisableAudioButton.SetActive(true)
            }
        }
    }
    
    
    func ToggleInfoMenu(on status: Bool)
    {
        mInfoBackButton.SetActive(status)
        mVirusImage.SetActive(status)
        mRedVirusImage.SetActive(status)
        mBombImage.SetActive(status)
        mPillImage.SetActive(status)
        mCoreImage.SetActive(status)
        
        mVirusInfo.SetActive(status)
        mRedVirusInfo.SetActive(status)
        mBombInfo.SetActive(status)
        mPillInfo.SetActive(status)
        mCoreInfo.SetActive(status)
    }
    
}
