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
    
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
        
    let mainMenuTitleLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    override func didMove(to view: SKView)
    {
        
        mainMenuTitleLabel.position = CGPoint(x: w/2, y: h/2)
        mainMenuTitleLabel.text = "Main Menu"
        mainMenuTitleLabel.fontSize = 48
        addChild(mainMenuTitleLabel)
        
    }
    
    func loadScene()
    {
        let gameScene = GameScene(fileNamed: "GameScene")
        view?.presentScene(gameScene)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        super.touchesEnded(touches, with: event)
        
        loadScene()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
        // Code called each frame before rendering
        
        
    }
    
}
