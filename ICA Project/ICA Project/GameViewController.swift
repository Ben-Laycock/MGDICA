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
    
    var gameScene : GameScene!
    var mainMenuScene : MainMenuScene!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        if let view = self.view as! SKView?
        {
            
            // Load the SKScene from 'GameScene.sks'
            if let gScene = GameScene(fileNamed: "GameScene")
            {
                gameScene = gScene
                
                // Make scene scale to fit the window
                gScene.scaleMode = .resizeFill
            }
            
            // Load to Main Menu scene
            if let mScene = MainMenuScene(fileNamed: "MainMenuScene")
            {
                mainMenuScene = mScene
                mScene.gameScene = gameScene
                
                // Make scene scale to fit the window
                mScene.scaleMode = .resizeFill
                
                view.presentScene(mScene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
        
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {

        if motion == .motionShake
        {
            print("Shake")
            gameScene.printHelloMessage()
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
