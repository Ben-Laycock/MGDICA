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
    
    // Main Menu
    let mMainMenuTitleLabel = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mPlayButton = SKSpriteNode(imageNamed: "PlayButton")
    let mOptionsButton = SKSpriteNode(imageNamed: "OptionsButton")
    let mInfoButton = SKSpriteNode(imageNamed: "InfoButton")
    
    
    // Options Menu
    let mSettingsTitleLabel = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mOptionsBackButton = SKSpriteNode(imageNamed: "ConfirmButton")
    let mAudioOptionLabel = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mDifficultyOptionLabel = SKLabelNode(fontNamed: "Noteworthy Bold")
    
    var mAudioEnabled : Bool = true
    var mDifficultySetting : Int = 1
    
    var mAudioToggle = CustomUIToggle()
    var mEasyDifficultyToggle = CustomUIToggle()
    var mMediumDifficultyToggle = CustomUIToggle()
    var mHardDifficultyToggle = CustomUIToggle()

    
    // Info Menu
    let mInfoBackButton = SKSpriteNode(imageNamed: "CancelButton")
    let mVirusImage = SKSpriteNode(imageNamed: "Virus")
    let mRedVirusImage = SKSpriteNode(imageNamed: "RedVirus")
    let mBombImage = SKSpriteNode(imageNamed: "Mine")
    let mPillImage = SKSpriteNode(imageNamed: "Pill")
    let mCoreImage = SKSpriteNode(imageNamed: "Core")
    
    let mVirusInfo = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mRedVirusInfo = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mBombInfo = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mPillInfo = SKLabelNode(fontNamed: "Noteworthy Bold")
    let mCoreInfo = SKLabelNode(fontNamed: "Noteworthy Bold")
    
    // Settings
    var mTitleFontSize : CGFloat = 48
    var mInfoFontSize : CGFloat = 24
    var mToggleSize : CGFloat = 50
    
    // Audio System
    var mAudioSystem : AudioSystem!
    
    var mSavedData = UserDefaults.standard
    var mHasCompleteSetup : Bool = false
    
    override func didMove(to view: SKView)
    {
        
        mAudioEnabled = mSavedData.bool(forKey: "AudioEnabled")
        if nil != mAudioSystem { mAudioSystem.UpdateSettings() }
        
        mDifficultySetting = mSavedData.integer(forKey: "Difficulty")
        if mDifficultySetting == 0
        {
            mSavedData.set(1, forKey: "Difficulty")
            mDifficultySetting = 1
        }
        
        // Exit function if setup has previously been completed
        if mHasCompleteSetup { return }
        
        mTitleFontSize = mScreenHeight/15
        mInfoFontSize = mScreenHeight/30
        mToggleSize = mScreenHeight/15
        
        // ===================  Main menu setup  ===================
        mMainMenuTitleLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 4 * 3)
        mMainMenuTitleLabel.text = "Main Menu"
        mMainMenuTitleLabel.fontSize = mTitleFontSize
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
        mSettingsTitleLabel.verticalAlignmentMode = .center
        mSettingsTitleLabel.horizontalAlignmentMode = .left
        mSettingsTitleLabel.text = "Settings"
        mSettingsTitleLabel.fontSize = mTitleFontSize
        mSettingsTitleLabel.position = CGPoint(
        x: mScreenWidth / 2,
        y: mScreenHeight / 6 * 5)
        addChild(mSettingsTitleLabel)
        
        mOptionsBackButton.name = "OptionsBackButton"
        mOptionsBackButton.position = CGPoint(x: mScreenHeight/8,
                                              y: mScreenHeight / 6 * 5)
        mOptionsBackButton.size = CGSize(width: mScreenHeight/8, height: mScreenHeight/8)
        addChild(mOptionsBackButton)
        
        mAudioOptionLabel.verticalAlignmentMode = .center
        mAudioOptionLabel.horizontalAlignmentMode = .left
        mAudioOptionLabel.text = "Audio"
        mAudioOptionLabel.fontSize = mInfoFontSize
        mAudioOptionLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 6 * 4)
        addChild(mAudioOptionLabel)
        
        mAudioToggle.SetScale(mToggleSize, mToggleSize)
        mAudioToggle.position = CGPoint(
            x: mScreenWidth / 2 + mAudioOptionLabel.frame.width + mToggleSize/2 + 20,
            y: mScreenHeight / 6 * 4)
        mAudioToggle.Setup(toggleName: "Audio", self)
        mAudioToggle.SetSelected(mAudioEnabled)
        
        
        mDifficultyOptionLabel.verticalAlignmentMode = .center
        mDifficultyOptionLabel.horizontalAlignmentMode = .left
        mDifficultyOptionLabel.text = "Difficulty"
        mDifficultyOptionLabel.fontSize = mInfoFontSize
        mDifficultyOptionLabel.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 6 * 3)
        addChild(mDifficultyOptionLabel)
        
        mEasyDifficultyToggle.SetScale(mToggleSize, mToggleSize)
        mEasyDifficultyToggle.position = CGPoint(
            x: mScreenWidth / 2 + mDifficultyOptionLabel.frame.width + mToggleSize/2 + 20,
            y: mScreenHeight / 6 * 3)
        mEasyDifficultyToggle.Setup(toggleName: "EasyDifficulty", self)
        mEasyDifficultyToggle.SetSelected(mDifficultySetting == 1)
        mEasyDifficultyToggle.mCanDeactivateOnTouch = false
        
        mMediumDifficultyToggle.SetScale(mToggleSize, mToggleSize)
        mMediumDifficultyToggle.position = CGPoint(
            x: mScreenWidth / 2 + mDifficultyOptionLabel.frame.width + mToggleSize/2 * 3 + 20 * 2,
            y: mScreenHeight / 6 * 3)
        mMediumDifficultyToggle.Setup(toggleName: "MediumDifficulty", self)
        mMediumDifficultyToggle.SetSelected(mDifficultySetting == 2)
        mMediumDifficultyToggle.mCanDeactivateOnTouch = false
        
        mHardDifficultyToggle.SetScale(mToggleSize, mToggleSize)
        mHardDifficultyToggle.position = CGPoint(
            x: mScreenWidth / 2 + mDifficultyOptionLabel.frame.width + mToggleSize/2 * 5 + 20 * 3,
            y: mScreenHeight / 6 * 3)
        mHardDifficultyToggle.Setup(toggleName: "HardDifficulty", self)
        mHardDifficultyToggle.SetSelected(mDifficultySetting == 3)
        mHardDifficultyToggle.mCanDeactivateOnTouch = false
        
        
        // ===================  Info menu setup  ===================
        mInfoBackButton.name = "InfoBackButton"
        mInfoBackButton.position = CGPoint(x: mScreenHeight/8,
                                       y: mScreenHeight / 6 * 5)
        mInfoBackButton.size = CGSize(width: mScreenHeight/8, height: mScreenHeight/8)
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
        mRedVirusInfo.text = "Red Virus: Swipe left / right to keep them away from the Core / Hit with bombs to destroy"
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
        mPillInfo.text = "Pill: Drag to the core to heal it (Can't have more health than you started with)"
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
        
        // Setup audio system
        mAudioSystem = AudioSystem()
        mAudioSystem.Setup()
        
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
                mAudioSystem.PlaySound(name: "click", from: self)
                loadScene()
            }
            
            if node.name == "InfoButton"
            {
                mAudioSystem.PlaySound(name: "click", from: self)
                ToggleMainMenu(on: false)
                ToggleOptionsMenu(on: false)
                ToggleInfoMenu(on: true)
            }
            
            if node.name == "OptionsButton"
            {
                mAudioSystem.PlaySound(name: "click", from: self)
                ToggleMainMenu(on: false)
                ToggleInfoMenu(on: false)
                ToggleOptionsMenu(on: true)
            }
            
            
            // Info Menu
            if node.name == "InfoBackButton"
            {
                mAudioSystem.PlaySound(name: "click", from: self)
                ToggleInfoMenu(on: false)
                ToggleOptionsMenu(on: false)
                ToggleMainMenu(on: true)
            }
            
            
            // Options menu
            if node.name == "OptionsBackButton"
            {
                mAudioSystem.PlaySound(name: "confirm", from: self)
                ToggleInfoMenu(on: false)
                ToggleOptionsMenu(on: false)
                ToggleMainMenu(on: true)
            }
            
            let touchedName = String(node.name ?? "none")
            
            if mAudioToggle.touchDetected(touchedName) { mAudioSystem.PlaySound(name: "toggle", from: self) }
            if mAudioToggle.IsSelected()
            {
                mAudioEnabled = true
                mSavedData.set(true, forKey: "AudioEnabled")
                mAudioSystem.UpdateSettings()
            }
            else
            {
                mAudioEnabled = false
                mSavedData.set(false, forKey: "AudioEnabled")
                mAudioSystem.UpdateSettings()
            }
            
            if mEasyDifficultyToggle.touchDetected(touchedName) { mAudioSystem.PlaySound(name: "toggle", from: self) }
            if mEasyDifficultyToggle.IsSelected()
            {
                mDifficultySetting = 1
                mSavedData.set(mDifficultySetting, forKey: "Difficulty")
                mMediumDifficultyToggle.SetSelected(false)
                mHardDifficultyToggle.SetSelected(false)
            }
            
            if mMediumDifficultyToggle.touchDetected(touchedName) { mAudioSystem.PlaySound(name: "toggle", from: self) }
            if mMediumDifficultyToggle.IsSelected()
            {
                mDifficultySetting = 2
                mSavedData.set(mDifficultySetting, forKey: "Difficulty")
                mEasyDifficultyToggle.SetSelected(false)
                mHardDifficultyToggle.SetSelected(false)
            }
            
            if mHardDifficultyToggle.touchDetected(touchedName) { mAudioSystem.PlaySound(name: "toggle", from: self) }
            if mHardDifficultyToggle.IsSelected()
            {
                mDifficultySetting = 3
                mSavedData.set(mDifficultySetting, forKey: "Difficulty")
                mEasyDifficultyToggle.SetSelected(false)
                mMediumDifficultyToggle.SetSelected(false)
            }
        }
        
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
        mSettingsTitleLabel.SetActive(status)
        mOptionsBackButton.SetActive(status)
        mAudioOptionLabel.SetActive(status)
        mDifficultyOptionLabel.SetActive(status)
        
        mAudioToggle.Toggle(status)
        mEasyDifficultyToggle.Toggle(status)
        mMediumDifficultyToggle.Toggle(status)
        mHardDifficultyToggle.Toggle(status)
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
