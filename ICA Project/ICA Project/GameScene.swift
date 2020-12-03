//
//  GameScene.swift
//  ICA Project
//
//  Created by LAYCOCK, BEN (Student) on 05/11/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit
import CoreMotion


class GameScene: SKScene
{
    
    // Scenes
    var mGameOverScene : GameOverScene!
    var mMainMenuScene : MainMenuScene!
    
    // Screen
    let mScreenWidth = UIScreen.main.bounds.width
    let mScreenHeight = UIScreen.main.bounds.height
    
    // Textures
    let mVirusTexture = SKTexture(imageNamed: "Virus")
    let mBombTexture = SKTexture(imageNamed: "Mine")
    let mCoreTexture = SKTexture(imageNamed: "Mine")
    
    // Viruses
    let mNumOfViruses = 50
    var mActiveViruses = Set<Virus>()
    var mInactiveViruses = Set<Virus>()
    
    // Bombs
    let mNumOfBombs = 10
    var mActiveBombs = Set<Bomb>()
    var mInactiveBombs = Set<Bomb>()
    
    // Core
    let mCoreStartingHealth = 20
    var mCore : Core!
    
    // Game Settings
    var mCurrentWave = 1
    
    // Audio
    var mAudioPlayer1 = AVAudioPlayer()
    
    // Score
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    var mScore = 0
    {
        didSet
        {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formatteScore = formatter.string(from: mScore as NSNumber) ?? "0"
            mScoreLabel.text = "SCORE: \(formatteScore)"
        }
    }
    
    // Device Motion
    let mMotionManager = CMMotionManager()
    // Accelerometer
    var accelerationThreshold = 2.0
    // Gyroscope variables
    var gyroVector = CGVector.zero
    var gyroChangePrecision = CGFloat(0.2)
    
    var mHasCompleteSetup = false
    
    override func didMove(to view: SKView)
    {
        
        if mHasCompleteSetup
        {
           return
        }
        
        // Setup Core
        mCore = Core(texture: mBombTexture, color: UIColor.clear, size: mCoreTexture.size(), health: mCoreStartingHealth)
        mCore.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 2)
        addChild(mCore)
        
        // Setup Viruses
        SetupViruses()
        
        // Setup Bombs
        SetupBombs()
        
        // Score label
        mScoreLabel.fontSize = 72
        mScoreLabel.position = CGPoint(x: mScreenWidth/2, y: mScoreLabel.fontSize/2)
        mScoreLabel.text = "SCORE: 0"
        mScoreLabel.zPosition = 100
        mScoreLabel.horizontalAlignmentMode = .center
        addChild(mScoreLabel)
        
        // Sounds
        let sound = Bundle.main.path(forResource: "Sounds/Beep.mp3", ofType: nil)
        do
        {
            mAudioPlayer1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch
        {
            print(error)
        }
        
        // Start motion manager (Accelerometer and Gyroscope)
        mMotionManager.startAccelerometerUpdates()
        mMotionManager.startGyroUpdates()
    
        mHasCompleteSetup = true
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        //let sound = Bundle.main.path(forResource: "Sounds/Beep.mp3", ofType: nil)
        
        //let playSound = SKAction.playSoundFileNamed("Sounds/Beep.mp3", waitForCompletion: true)
        //self.run(playSound)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        super.touchesEnded(touches, with: event)
        
        for touch in touches
        {
            let pos = touch.location(in: self) // Position of the touch
            let node = atPoint(pos) // Node at the touch position
            
            // What happens per touched object type?
            
            // Virus
            if node is Virus
            {
                let currentVirus = node as! Virus
                currentVirus.DecreaseHealth(by: 1)
                // Check if virus died
                if !currentVirus.mIsAlive
                {
                    mScore += 1;
                    mActiveViruses.remove(currentVirus)
                    mInactiveViruses.insert(currentVirus)
                }
            }
            
            // Bomb
            if node is Bomb
            {
                view?.Shake(horizontalShake: CGFloat.random(in: -20.0...20.0), verticalShake: CGFloat.random(in: -20.0...20.0))
                
                let currentBomb = node as! Bomb
                for virus in mActiveViruses
                {
                    
                    let vectorToVirus = virus.position.ToVector() - currentBomb.position.ToVector()
                    let distToVirus = vectorToVirus.Mag()
                    if Float(distToVirus) <= currentBomb.mExplosionRadius
                    {
                        virus.DecreaseHealth(by: currentBomb.mExplosionDamage)
                        if !virus.mIsAlive
                        {
                            mScore += 1;
                            mActiveViruses.remove(virus)
                            mInactiveViruses.insert(virus)
                        }
                    }
                }
                
                // Remove bomb
                currentBomb.mIsAlive = false
                mActiveBombs.remove(currentBomb)
                mInactiveBombs.insert(currentBomb)
            }
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    /*
    func printHelloMessage()
    {
        print("Hello from GameScene")
    }
    */
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
        // Accelerometer
        if let accelerometer = mMotionManager.accelerometerData
        {
            if abs(accelerometer.acceleration.z) > accelerationThreshold
            {
                print("Shake \(Float.random(in: 1.0...100.0))")
                // What should happen when the device is shaken?
                // Push viruses to edge of the screen
            }
            
            //print("A  X: " + String(accelerometer.acceleration.x) + "     Y: " + String(accelerometer.acceleration.y) + "     Z: " + String(accelerometer.acceleration.z))
        }
        
        // Gyroscope
        if let gyroscope = mMotionManager.gyroData
        {
            let newGyroVector = CGVector(dx: gyroscope.rotationRate.x, dy: gyroscope.rotationRate.y)
            
            gyroVector = newGyroVector.Norm()

            
            //print("G  X: " + String(gyroscope.rotationRate.x) + "     Y: " + String(gyroscope.rotationRate.y) + "     Z: " + String(gyroscope.rotationRate.z))
        }
        
        // Check if game should end
        if mCore.mHealth <= 0
        {
            // Also done when loading back into this scene
            // however making this check could prevent a bug
            if ResetScene()
            {
                loadGameOverScene()
            }
        }
        
        // Setup for virus scale animation
        let origionalScale = mVirusTexture.size().width * 0.2
        let modification = CGFloat(abs(sin(currentTime)))
        let newScale = origionalScale + (origionalScale * modification)
        let resizeVirus = SKAction.resize(toWidth: newScale, height: newScale, duration: 0.5)
        
        // Code called each frame before rendering
        
        // Viruses
        for virus in mInactiveViruses
        {
            virus.mIsAlive = false // Inactive viruses shouldn't be alive
            virus.Update()
        }
        
        for virus in mActiveViruses
        {
            // Direction to target
            let dirToTarget = virus.mTargetPosition.ToVector() - virus.position.ToVector()
            if dirToTarget.Mag() <= CGFloat(virus.mDamageRange)
            {
                //mCore.mHealth -= 1
                virus.mIsAlive = false
                mActiveViruses.remove(virus)
                mInactiveViruses.insert(virus)
            }
            
            // Manage current active virus
            virus.Update()
            virus.run(resizeVirus)
        }
          
        // Bombs
        for bomb in mInactiveBombs
        {
            bomb.mMovementDirection = bomb.mMovementDirection + gyroVector
            bomb.mIsAlive = false // Inactive bombs shouldn't be alive
            bomb.Update()
        }
        
        for bomb in mActiveBombs
        {
            // Manage current active bombs
            bomb.mMovementDirection = bomb.mMovementDirection + gyroVector
            bomb.Update()
            //bomb.run(resizeVirus)
        }
        
        // Random spawning of viruses
        let pos = CGPoint(x: CGFloat(Float.random(in: 1.0...Float(mScreenWidth))), y: CGFloat(Float.random(in: 1.0...Float(mScreenHeight))))
        SpawnVirus(at: pos, health: 1, speed: 50.0)
        
        // Limit scene to 1 bomb
        if mActiveBombs.count <= 0
        {
            SpawnBomb(at: pos, speed: 20.0, explosionRange: 200.0, explosionDamage: 5)
        }
        
    }
    
    
    func CreateVirus(texture tex: SKTexture,
                     health h: Int,
                     movementSpeed mS: Float) -> (Virus)
    {
        let newVirus = Virus(texture: tex, color: UIColor.clear, size: tex.size(), health: h, movementSpeed: mS)
        
        return newVirus;
    }
    
    func SpawnVirus(at p: CGPoint, health h: Int, speed s: Float)
    {
        
        if mInactiveViruses.isEmpty
        {
            return
        }
        
        let inactiveVirus = mInactiveViruses.popFirst()
        mActiveViruses.insert(inactiveVirus!)
        
        inactiveVirus?.position = p
        inactiveVirus?.mHealth = h
        inactiveVirus?.mMovementSpeed = s
        inactiveVirus?.mIsAlive = true
        
    }
    
    
    func CreateBomb(texture tex: SKTexture,
                    movementSpeed mS: Float,
                    explosionRange eRange: Float,
                    explosionDamage eDamage: Int) -> (Bomb)
    {
        let newBomb = Bomb(texture: tex, color: UIColor.clear, size: tex.size(), movementSpeed: mS, explosionRange: eRange, explosionDamage: eDamage)
        
        return newBomb;
    }
    
    func SpawnBomb(at p: CGPoint,
                   speed s: Float,
                   explosionRange eRange: Float,
                   explosionDamage eDamage: Int)
    {
        
        if mInactiveBombs.isEmpty
        {
            return
        }
        
        let inactiveBomb = mInactiveBombs.popFirst()
        mActiveBombs.insert(inactiveBomb!)
        
        inactiveBomb?.position = p
        inactiveBomb?.mMovementSpeed = s
        inactiveBomb?.mExplosionRadius = eRange
        inactiveBomb?.mExplosionDamage = eDamage
        inactiveBomb?.mIsAlive = true
        
    }
    
    
    func SetupViruses()
    {
        
        for _ in 1...mNumOfViruses
        {
            let newVirus = CreateVirus(texture: mVirusTexture, health: 1, movementSpeed: 20.0)
            
            mInactiveViruses.insert(newVirus)
            
            newVirus.position = CGPoint(x: mScreenWidth - 100.0, y: mScreenHeight / 2)
            newVirus.size = CGSize(width: mVirusTexture.size().width, height: mVirusTexture.size().height) * 0.2
            newVirus.physicsBody = SKPhysicsBody(circleOfRadius: mVirusTexture.size().width)
            newVirus.physicsBody?.affectedByGravity = false
            newVirus.physicsBody?.collisionBitMask = 0x00000000

            newVirus.mTargetPosition = mCore.position
            newVirus.mIsAlive = false
            
            addChild(newVirus)
        }
        
    }
    
    func SetupBombs()
    {
        
        for _ in 1...mNumOfBombs
        {
            let newBomb = CreateBomb(texture: mBombTexture, movementSpeed: 20.0, explosionRange: 200.0, explosionDamage: 5)
            
            mInactiveBombs.insert(newBomb)
            
            newBomb.position = CGPoint(x: mScreenWidth - 100.0, y: mScreenHeight / 2)
            newBomb.size = CGSize(width: mBombTexture.size().width, height: mBombTexture.size().height) * 0.4
            newBomb.physicsBody = SKPhysicsBody(circleOfRadius: mBombTexture.size().width)
            newBomb.physicsBody?.affectedByGravity = false
            newBomb.physicsBody?.collisionBitMask = 0x00000000

            newBomb.mIsAlive = false
            
            addChild(newBomb)
        }
        
    }
    
    func ResetScene() -> (Bool)
    {
        
        // Viruses
        for virus in mActiveViruses
        {
            virus.mIsAlive = false
            mActiveViruses.remove(virus)
            mInactiveViruses.insert(virus)
            virus.Update()
        }
        
        // Bombs
        for bomb in mActiveBombs
        {
            bomb.mIsAlive = false
            mActiveBombs.remove(bomb)
            mInactiveBombs.insert(bomb)
            bomb.Update()
        }
        
        // Core
        mCore.mIsDestroyed = false
        mCore.mHealth = mCoreStartingHealth
        
        // Score
        mScore = 0
        mScoreLabel.text = "SCORE: 0"
        
        // Game Settings
        mCurrentWave = 1
        
        return true
        
    }
    
    func loadGameOverScene()
    {
        view?.presentScene(mGameOverScene, transition: .reveal(with: SKTransitionDirection.up, duration: 1.0))
        //view?.presentScene(mGameOverScene)
    }
    
    func loadMainMenuScene()
    {
        view?.presentScene(mMainMenuScene, transition: .reveal(with: SKTransitionDirection.right, duration: 1.0))
        //view?.presentScene(mMainMenuScene)
    }

}
