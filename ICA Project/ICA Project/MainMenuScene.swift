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
    let mOptionsButton = SKSpriteNode(imageNamed: "OptionsButton")
    let mInfoButton = SKSpriteNode(imageNamed: "InfoButton")
    
    
    // Options Menu
    let mOptionsBackButton = SKSpriteNode(imageNamed: "ConfirmButton")
    let mAudioOptionLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    var mAudioEnabled : Bool = true
    var mDifficultySetting : Int = 1
    
    var mAudioToggle = CustomUIToggle()
    var mEasyDifficultyToggle = CustomUIToggle()

    
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
    
    // Settings
    var mInfoFontSize : CGFloat = 24
    
    var mSavedData = UserDefaults.standard
    var mHasCompleteSetup : Bool = false
    
    
    override func didMove(to view: SKView)
    {
        
        mAudioEnabled = mSavedData.bool(forKey: "AudioEnabled")
        
        mDifficultySetting = mSavedData.integer(forKey: "Difficulty")
        if mDifficultySetting == 0 { mSavedData.set(1, forKey: "Difficulty") }
        
        // Exit function if setup has previously been completed
        if mHasCompleteSetup { return }
        
        mInfoFontSize = mScreenHeight/20
        
        // ===================  Main menu setup  ===================
        mMainMenuTitleLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 4 * 3)
        mMainMenuTitleLabel.text = "Main Menu"
        mMainMenuTitleLabel.fontSize = 48
        addChild(mMainMenuTitleLabel)
        
        // Play button
        mPlayButton.name = "PlayButton"
        mPlayButton.position = CGPoint(x: mScreenWidth / 6 * 2, y: mScreenHeight / 6 * 2)
        mPlayButton.size = CGSize(width: mScreenHeight/8, height: mScreenHeight/8)
        addChild(mPlayButton)
        
        // Options button
        mOptionsButton.name = "OptionsButton"
        mOptionsButton.position = CGPoint(x: mScreenWidth / 6 * 3, y: mScreenHeight / 6 * 2)
        mOptionsButton.size = CGSize(width: mScreenHeight/8, height: mScreenHeight/8)
        addChild(mOptionsButton)
        
        // Info button
        mInfoButton.name = "InfoButton"
        mInfoButton.position = CGPoint(x: mScreenWidth / 6 * 4, y: mScreenHeight / 6 * 2)
        mInfoButton.size = CGSize(width: mScreenHeight/8, height: mScreenHeight/8)
        addChild(mInfoButton)
        
        
        // ===================  Options menu setup  ===================
        mOptionsBackButton.name = "OptionsBackButton"
        mOptionsBackButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 5)
        mOptionsBackButton.size = SKTexture(imageNamed: "ConfirmButton").size() * 0.3
        addChild(mOptionsBackButton)
        
        mAudioOptionLabel.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 2)
        mAudioOptionLabel.verticalAlignmentMode = .center
        mAudioOptionLabel.text = "Audio"
        mAudioOptionLabel.fontSize = 36
        addChild(mAudioOptionLabel)
        
        mAudioToggle.SetScale(mScreenHeight/10, mScreenHeight/10)
        mAudioToggle.position = CGPoint(x: mScreenWidth / 3 + mAudioOptionLabel.frame.width/2 + mAudioToggle.mOnImage.size.width/2 + 20, y: mScreenHeight / 2)
        mAudioToggle.Setup(toggleName: "Audio", self)
        mAudioToggle.SetSelected(mAudioEnabled)
        
        mEasyDifficultyToggle.position = CGPoint(x: 100.0, y: 100.0)
        mEasyDifficultyToggle.Setup(toggleName: "EasyDifficulty", self)
        mEasyDifficultyToggle.SetScale(mScreenHeight/10, mScreenHeight/10)
        
        
        // ===================  Info menu setup  ===================
        mInfoBackButton.name = "InfoBackButton"
        mInfoBackButton.position = CGPoint(x: 10 + SKTexture(imageNamed: "PlayButton").size().width / 2,
                                       y: mScreenHeight / 6 * 5)
        mInfoBackButton.size = SKTexture(imageNamed: "CancelButton").size() * 0.3
        addChild(mInfoBackButton)
        
        // Virus
        mVirusImage.name = "VirusImage"
        mVirusImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6)
        mVirusImage.size = CGSize(width: mScreenWidth/15, height: mScreenWidth/15)
        addChild(mVirusImage)
        
        mVirusInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6)
        mVirusInfo.horizontalAlignmentMode = .left
        mVirusInfo.verticalAlignmentMode = .center
        mVirusInfo.text = "Virus: Click to destroy / Hit them with bombs (Gets stronger per round)"
        mVirusInfo.numberOfLines = 2
        mVirusInfo.preferredMaxLayoutWidth = mScreenWidth / 2
        mVirusInfo.fontSize = mInfoFontSize
        addChild(mVirusInfo)
        
        // Red Virus
        mRedVirusImage.name = "RedVirusImage"
        mRedVirusImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 2)
        mRedVirusImage.size = CGSize(width: mScreenWidth/15, height: mScreenWidth/15)
        addChild(mRedVirusImage)
        
        mRedVirusInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 2)
        mRedVirusInfo.horizontalAlignmentMode = .left
        mRedVirusInfo.verticalAlignmentMode = .center
        mRedVirusInfo.text = "Red Virus: Swipe away / Hit with bombs"
        mRedVirusInfo.numberOfLines = 2
        mRedVirusInfo.preferredMaxLayoutWidth = mScreenWidth / 2
        mRedVirusInfo.fontSize = mInfoFontSize
        addChild(mRedVirusInfo)
        
        // Bomb
        mBombImage.name = "BombImage"
        mBombImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 3)
        mBombImage.size = CGSize(width: mScreenWidth/15, height: mScreenWidth/15)
        addChild(mBombImage)
        
        mBombInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 3)
        mBombInfo.horizontalAlignmentMode = .left
        mBombInfo.verticalAlignmentMode = .center
        mBombInfo.text = "Bomb: Hit viruses to cause an explosion"
        mBombInfo.numberOfLines = 2
        mBombInfo.preferredMaxLayoutWidth = mScreenWidth / 2
        mBombInfo.fontSize = mInfoFontSize
        addChild(mBombInfo)
        
        // Pill
        mPillImage.name = "PillImage"
        mPillImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 4)
        mPillImage.size = CGSize(width: mScreenWidth/15, height: mScreenWidth/15)
        addChild(mPillImage)
        
        mPillInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 4)
        mPillInfo.horizontalAlignmentMode = .left
        mPillInfo.verticalAlignmentMode = .center
        mPillInfo.text = "Pill: Drag to the core to heal it"
        mPillInfo.numberOfLines = 2
        mPillInfo.preferredMaxLayoutWidth = mScreenWidth / 2
        mPillInfo.fontSize = mInfoFontSize
        addChild(mPillInfo)
        
        // Core
        mCoreImage.name = "CoreImage"
        mCoreImage.position = CGPoint(x: mScreenWidth / 3, y: mScreenHeight / 6 * 5)
        mCoreImage.size = CGSize(width: mScreenWidth/15, height: mScreenWidth/15)
        addChild(mCoreImage)
        
        mCoreInfo.position = CGPoint(x: mScreenWidth / 3 + 75, y: mScreenHeight / 6 * 5)
        mCoreInfo.horizontalAlignmentMode = .left
        mCoreInfo.verticalAlignmentMode = .center
        mCoreInfo.text = "Core: Protect it from the viruses"
        mCoreInfo.numberOfLines = 2
        mCoreInfo.preferredMaxLayoutWidth = mScreenWidth / 2
        mCoreInfo.fontSize = mInfoFontSize
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
            
            // Main Menu
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
            
            
            // Info Menu
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
            
            let touchedName = String(node.name ?? "none")
            
            mAudioToggle.touchDetected(touchedName)
            if mAudioToggle.IsSelected()
            {
                mAudioEnabled = true
                mSavedData.set(true, forKey: "AudioEnabled")
            }
            else
            {
                mAudioEnabled = false
                mSavedData.set(false, forKey: "AudioEnabled")
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

        mAudioToggle.Toggle(status)
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
