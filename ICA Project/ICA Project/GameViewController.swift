//
//  GameViewController.swift
//  ICA Project
//
//  Created by LAYCOCK, BEN (Student) on 05/11/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController
{
    
    var mGameOverScene : GameOverScene!
    var mGameScene : GameScene!
    var mMainMenuScene : MainMenuScene!
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        if let view = self.view as! SKView?
        {
            
            // Load game over scene
            if let goScene = GameOverScene(fileNamed: "GameOverScene")
            {
                mGameOverScene = goScene
                
                // Make scene scale to fit the window
                goScene.scaleMode = .resizeFill
            }
            
            // Load game scene
            if let gScene = GameScene(fileNamed: "GameScene")
            {
                mGameScene = gScene
                
                // Make scene scale to fit the window
                gScene.scaleMode = .resizeFill
            }
            
            // Load main menu scene
            if let mScene = MainMenuScene(fileNamed: "MainMenuScene")
            {
                mMainMenuScene = mScene
                
                // Make scene scale to fit the window
                mScene.scaleMode = .resizeFill
                
                view.presentScene(mScene)
            }
            
            // Game scene
            mGameScene.mMainMenuScene = mMainMenuScene
            mGameScene.mGameOverScene = mGameOverScene
            
            // Main menu scene
            mMainMenuScene.mGameScene = mGameScene
            
            // Game over scene
            mGameOverScene.mGameScene = mGameScene
            mGameOverScene.mMainMenuScene = mMainMenuScene
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
        
    }
    
    
    override var shouldAutorotate: Bool
    {
        return true
    }

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            return .allButUpsideDown
        }
        else
        {
            return .all
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
